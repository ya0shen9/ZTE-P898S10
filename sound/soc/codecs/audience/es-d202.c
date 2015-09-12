/*
 * es-d202.c  --  Audience es D202 component ALSA Audio driver
 *
 * Copyright 2011 Audience, Inc.
 *
 * Author: Greg Clemson <gclemson@audience.com>
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/init.h>
#include <linux/firmware.h>
#include <linux/delay.h>
#include <linux/pm.h>
#include <linux/completion.h>
#include <linux/gpio.h>
#include <linux/platform_device.h>
#include <linux/regulator/consumer.h>
#include <linux/slab.h>
#include <linux/err.h>
#include <sound/core.h>
#include <sound/pcm.h>
#include <sound/pcm_params.h>
#include <sound/soc.h>
#include <sound/soc-dai.h>
#include <sound/soc-dapm.h>
#include <sound/initval.h>
#include <sound/tlv.h>
#include <linux/kthread.h>
#include <linux/device.h>
#include <linux/pm_runtime.h>
#include <linux/mutex.h>
#include <linux/wait.h>
#include "escore.h"
#include "es515.h"
#include "escore-list.h"
#include "es-d202.h"



unsigned int cachedcmd_list[ES_API_ADDR_MAX];

static const u16 input_mux_text_to_api[] = {
	0xffff, /* Default value for all input MUXes */
	DATA_PATH(0, PCM0, 0), DATA_PATH(0, PCM0, 1),
	DATA_PATH(0, PCM0, 2), DATA_PATH(0, PCM0, 3),
	DATA_PATH(0, PCM1, 0), DATA_PATH(0, PCM1, 1),
	DATA_PATH(0, PCM1, 2), DATA_PATH(0, PCM1, 3),
	DATA_PATH(0, PCM2, 0), DATA_PATH(0, PCM2, 1),
	DATA_PATH(0, PCM2, 2), DATA_PATH(0, PCM2, 3),
	DATA_PATH(0, SBUS, 0), DATA_PATH(0, SBUS, 1),
	DATA_PATH(0, SBUS, 2), DATA_PATH(0, SBUS, 3),
	DATA_PATH(0, SBUS, 4), DATA_PATH(0, SBUS, 5),
	DATA_PATH(0, SBUS, 6), DATA_PATH(0, SBUS, 7),
	DATA_PATH(0, SBUS, 8), DATA_PATH(0, SBUS, 9),
	DATA_PATH(0, ADC1, 0),
	DATA_PATH(0, ADC2, 0),
	DATA_PATH(0, ADC3, 0),
};

static const u16 output_mux_text_to_api[] = {
	0xffff, /* Default value for all output MUXes */
	DATA_PATH(CSOUT, 0, 0), DATA_PATH(FEOUT1, 0, 0),
	DATA_PATH(FEOUT2, 0, 0), DATA_PATH(CSOUT, 0, 0),
	DATA_PATH(CSOUT, 0, 0), DATA_PATH(AUDOUT1, 0, 0),
	DATA_PATH(AUDOUT2, 0, 0), DATA_PATH(AUDOUT1, 0, 0),
	DATA_PATH(AUDOUT2, 0, 0), DATA_PATH(AUDOUT3, 0 , 0),
	DATA_PATH(AUDOUT4, 0 , 0),
};

static int put_control_enum(struct snd_kcontrol *kcontrol,
				  struct snd_ctl_elem_value *ucontrol)
{
	struct snd_soc_codec *codec = escore_priv.codec;
	struct escore_priv *escore = snd_soc_codec_get_drvdata(codec);
	struct soc_enum *e =
		(struct soc_enum *)kcontrol->private_value;
	unsigned int reg = e->reg;
	unsigned int value;
	int msg_len;
	char msg[8] = { 0 };
	int rc = 0;

	value = ucontrol->value.enumerated.item[0];
	rc = escore_prepare_msg(escore, reg, value, msg, &msg_len,
			ES_MSG_WRITE);
	if (rc) {
		pr_err("%s(): Preparing write message failed\n", __func__);
		goto out;
	}

	escore_queue_msg_to_list(escore, msg, msg_len);
	/* add command and value to cache,which
	 * feeds in responsding to "get" control commands*/
	cachedcmd_list[reg] = value;

out:
	return rc;
}

static int get_control_enum(struct snd_kcontrol *kcontrol,
				  struct snd_ctl_elem_value *ucontrol)
{
	struct soc_enum *e =
		(struct soc_enum *)kcontrol->private_value;
	unsigned int reg = e->reg;
	unsigned int value;

	value = cachedcmd_list[reg];
	ucontrol->value.enumerated.item[0] = value;

	return 0;
}

static int put_digital_gain(struct snd_kcontrol *kcontrol,
			    struct snd_ctl_elem_value *ucontrol)
{
	struct snd_soc_codec *codec = escore_priv.codec;
	struct escore_priv *escore = snd_soc_codec_get_drvdata(codec);
	struct soc_mixer_control *mc =
		(struct soc_mixer_control *)kcontrol->private_value;
	unsigned int reg = mc->reg;
	unsigned int value;
	int msg_len;
	char msg[8] = { 0 };
	int rc = 0;

	value = ucontrol->value.integer.value[0];
	rc = escore_prepare_msg(escore, reg, value, msg, &msg_len,
			ES_MSG_WRITE);
	if (rc) {
		pr_err("%s(): Preparing write message failed\n", __func__);
		goto out;
	}
	escore_queue_msg_to_list(escore, msg, msg_len);

	/* add command and value to cache,which
	 * feeds in responsding to "get" control commands*/
	cachedcmd_list[reg] = value;

out:
	return rc;
}

static int get_digital_gain(struct snd_kcontrol *kcontrol,
			    struct snd_ctl_elem_value *ucontrol)
{
	/* struct snd_soc_codec *codec = escore_priv.codec; */
	struct soc_mixer_control *mc =
		(struct soc_mixer_control *)kcontrol->private_value;
	unsigned int reg = mc->reg;
	unsigned int value;

	value = cachedcmd_list[reg];
	ucontrol->value.integer.value[0] = value;

	return 0;
}

static int put_input_route_value(struct snd_kcontrol *kcontrol,
				 struct snd_ctl_elem_value *ucontrol)
{
	struct snd_soc_dapm_widget_list *wlist = snd_kcontrol_chip(kcontrol);
	struct snd_soc_dapm_widget *widget = wlist->widgets[0];
	struct snd_soc_codec *codec = escore_priv.codec;
	struct escore_priv *escore = snd_soc_codec_get_drvdata(codec);
	struct soc_enum *e =
		(struct soc_enum *)kcontrol->private_value;
	unsigned int reg = e->reg;
	unsigned int value;
	int mux = ucontrol->value.enumerated.item[0];
	int msg_len;
	char msg[8] = { 0 };
	int rc = 0;

	value = input_mux_text_to_api[ucontrol->value.enumerated.item[0]];
	/* rc = escore_write(NULL, reg, value); */
	rc = escore_prepare_msg(escore, reg, value, msg, &msg_len,
			ES_MSG_WRITE);
	if (rc) {
		pr_err("%s(): Preparing write message failed\n", __func__);
		goto out;
	}

	escore_queue_msg_to_list(escore, msg, msg_len);

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 4, 0)
	snd_soc_dapm_mux_update_power(widget, kcontrol, mux, e);
#else
	snd_soc_dapm_mux_update_power(widget, kcontrol, 1, mux, e);
#endif
	cachedcmd_list[reg] = ucontrol->value.enumerated.item[0];
	pr_info("put input reg %d value 0x%08x", reg, cachedcmd_list[reg]);

out:
	return rc;
}

static int get_input_route_value(struct snd_kcontrol *kcontrol,
				 struct snd_ctl_elem_value *ucontrol)
{
	struct soc_enum *e =
		(struct soc_enum *)kcontrol->private_value;
	unsigned int reg = e->reg;
	unsigned int value;

	value = cachedcmd_list[reg];

	/* TBD: translation */
	/* value = escore_read(NULL, reg); */
	ucontrol->value.enumerated.item[0] = value;
	pr_info("get input reg %d value 0x%08x", reg, value);

	return 0;
}
static int put_output_route_value(struct snd_kcontrol *kcontrol,
				  struct snd_ctl_elem_value *ucontrol)
{
	struct snd_soc_dapm_widget_list *wlist = snd_kcontrol_chip(kcontrol);
	struct snd_soc_dapm_widget *widget = wlist->widgets[0];
	struct snd_soc_codec *codec = escore_priv.codec;
	struct escore_priv *escore = snd_soc_codec_get_drvdata(codec);
	struct soc_enum *e =
		(struct soc_enum *)kcontrol->private_value;
	unsigned int reg = e->reg;
	unsigned int value;
	int msg_len;
	char msg[8] = { 0 };
	int rc = 0;
	int mux = ucontrol->value.enumerated.item[0];

	value = output_mux_text_to_api[ucontrol->value.enumerated.item[0]];
	/* rc = escore_write(NULL, reg, value); */
	rc = escore_prepare_msg(escore, reg, value, msg, &msg_len,
			ES_MSG_WRITE);
	if (rc) {
		pr_err("%s(): Preparing write message failed\n", __func__);
		goto out;
	}

	escore_queue_msg_to_list(escore, msg, msg_len);

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 4, 0)
	snd_soc_dapm_mux_update_power(widget, kcontrol, mux, e);
#else
	snd_soc_dapm_mux_update_power(widget, kcontrol, 1, mux, e);
#endif
	cachedcmd_list[reg] = ucontrol->value.enumerated.item[0];
	pr_info("put output reg %d value 0x%08x", reg, cachedcmd_list[reg]);

out:
	return rc;
}
static int get_output_route_value(struct snd_kcontrol *kcontrol,
				  struct snd_ctl_elem_value *ucontrol)
{
	struct soc_enum *e =
		(struct soc_enum *)kcontrol->private_value;
	unsigned int reg = e->reg;
	unsigned int value;

	value = cachedcmd_list[reg];

	/* TBD: translation */
	/* value = escore_read(NULL, reg); */
	ucontrol->value.enumerated.item[0] = value;
	pr_info("get output reg %d value 0x%08x", reg, value);

	return 0;
}

static int write_route_cmds(struct snd_kcontrol *kcontrol,
			    struct snd_ctl_elem_value *ucontrol)
{
	escore_write_msg_list(NULL);

	return 0;
}

static int flush_route_cmds(struct snd_kcontrol *kcontrol,
			    struct snd_ctl_elem_value *ucontrol)
{
	escore_flush_msg_list(NULL);

	return 0;
}

/* controls */
static const char * const algorithm_texts[] = {
	"NONE", "VP", "AudioZoom", "MM", "Pass"
};
static const struct soc_enum algorithm_enum =
	SOC_ENUM_SINGLE(ES_ALGORITHM, 0,
			ARRAY_SIZE(algorithm_texts),
			algorithm_texts);

static const char * const algorithm_rate_texts[] = {
	"NB", "WB", "SWB", "FB"
};
/*replaced for ES_ALGORITHM_RATE*/
static const struct soc_enum algorithm_rate_enum =
	SOC_ENUM_SINGLE(ES_ALGO_SAMPLE_RATE, 0,
			ARRAY_SIZE(algorithm_rate_texts),
			algorithm_rate_texts);

static const struct snd_kcontrol_new es_d202_snd_controls[] = {
	SOC_ENUM_EXT("Algorithm", algorithm_enum,
			 get_control_enum, put_control_enum),
	SOC_ENUM_EXT("Algorithm Rate", algorithm_rate_enum,
			 get_control_enum, put_control_enum),
	SOC_SINGLE_EXT("VP Primary Gain", ES_DIGITAL_GAIN_PRIMARY, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP Secondary Gain", ES_DIGITAL_GAIN_SECONDARY,
			0, 255, 0, get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP Teritary Gain", ES_DIGITAL_GAIN_TERTIARY, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP FEIN Gain", ES_DIGITAL_GAIN_FEIN, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP UITONE1 Gain", ES_DIGITAL_GAIN_UITONE1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP UITONE2 Gain", ES_DIGITAL_GAIN_UITONE2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP AECREF1 Gain", ES_AECREF1_GAIN	, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP CSOUT Gain", ES_DIGITAL_GAIN_CSOUT, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP FEOUT1 Gain", ES_DIGITAL_GAIN_FEOUT1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("VP FEOUT2 Gain", ES_DIGITAL_GAIN_FEOUT2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("AudioZoom Primary Gain", ES_DIGITAL_GAIN_PRIMARY,
			0, 255, 0, get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("AudioZoom Secondary Gain", ES_DIGITAL_GAIN_SECONDARY,
			0, 255, 0, get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("AudioZoom CSOUT Gain", ES_DIGITAL_GAIN_CSOUT, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDIN1 Gain", ES_DIGITAL_GAIN_AUDIN1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDIN2 Gain", ES_DIGITAL_GAIN_AUDIN2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDIN3 Gain", ES_DIGITAL_GAIN_AUDIN3, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDIN4 Gain", ES_DIGITAL_GAIN_AUDIN4, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM UITONE1 Gain", ES_DIGITAL_GAIN_UITONE1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM UITONE2 Gain", ES_DIGITAL_GAIN_UITONE2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDOUT1 Gain", ES_DIGITAL_GAIN_AUDOUT1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDOUT2 Gain", ES_DIGITAL_GAIN_AUDOUT2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDOUT3 Gain", ES_DIGITAL_GAIN_AUDOUT3, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("MM AUDOUT4 Gain", ES_DIGITAL_GAIN_AUDOUT4, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDIN1 Gain", ES_DIGITAL_GAIN_AUDIN1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDIN2 Gain", ES_DIGITAL_GAIN_AUDIN2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDIN3 Gain", ES_DIGITAL_GAIN_AUDIN3, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDIN4 Gain", ES_DIGITAL_GAIN_AUDIN4, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass UITONE1 Gain", ES_DIGITAL_GAIN_UITONE1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass UITONE2 Gain", ES_DIGITAL_GAIN_UITONE2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDOUT1 Gain", ES_DIGITAL_GAIN_AUDOUT1, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDOUT2 Gain", ES_DIGITAL_GAIN_AUDOUT2, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDOUT3 Gain", ES_DIGITAL_GAIN_AUDOUT3, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Pass AUDOUT4 Gain", ES_DIGITAL_GAIN_AUDOUT4, 0, 255, 0,
		       get_digital_gain, put_digital_gain),
	SOC_SINGLE_EXT("Write Route Cmds", SND_SOC_NOPM, 0, 0, 0,
		       NULL, write_route_cmds),
	SOC_SINGLE_EXT("Flush Route Cmds", SND_SOC_NOPM, 0, 0, 0,
		       NULL, flush_route_cmds),
};


static const char * const proc_block_input_texts[] = {
	"NULL",
	"PCM0.0", "PCM0.1", "PCM0.2", "PCM0.3",
	"PCM1.0", "PCM1.1", "PCM1.2", "PCM1.3",
	"PCM2.0", "PCM2.1", "PCM2.2", "PCM2.3",
	"SBUS.RX0", "SBUS.RX1", "SBUS.RX2", "SBUS.RX3",
	"SBUS.RX4", "SBUS.RX5", "SBUS.RX6", "SBUS.RX7",
	"SBUS.RX8", "SBUS.RX9",
	"ADC1", "ADC2", "ADC3",
};

static const char * const proc_block_output_texts[] = {
	"NULL",
	"VP CSOUT", "VP FEOUT1", "VP FEOUT2",
	"AudioZoom CSOUT",
	"MM CSOUT", "MM AUDOUT1", "MM AUDOUT2",
	"Pass AUDOUT1", "Pass AUDOUT2", "Pass AUDOUT3", "Pass AUDOUT4",
};

static const struct soc_enum vp_pri_enum =
	SOC_ENUM_SINGLE(ES_PRIMARY_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_vp_pri_control =
	SOC_DAPM_ENUM_EXT("VP Primary MUX Mux", vp_pri_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum vp_sec_enum =
	SOC_ENUM_SINGLE(ES_SECONDARY_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_vp_sec_control =
	SOC_DAPM_ENUM_EXT("VP Secondary MUX Mux", vp_sec_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum vp_ter_enum =
	SOC_ENUM_SINGLE(ES_TERITARY_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_vp_ter_control =
	SOC_DAPM_ENUM_EXT("VP Teritary MUX Mux", vp_ter_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum vp_aecref1_enum =
	SOC_ENUM_SINGLE(ES_AECREF1_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_vp_aecref1_control =
	SOC_DAPM_ENUM_EXT("VP AECREF1 MUX Mux", vp_aecref1_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum vp_fein_enum =
	SOC_ENUM_SINGLE(ES_FEIN_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_vp_fein_control =
	SOC_DAPM_ENUM_EXT("VP FEIN MUX Mux", vp_fein_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum vp_uitone1_enum =
	SOC_ENUM_SINGLE(ES_UITONE1_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_vp_uitone1_control =
	SOC_DAPM_ENUM_EXT("VP UITONE1 MUX Mux", vp_uitone1_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum vp_uitone2_enum =
	SOC_ENUM_SINGLE(ES_UITONE2_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_vp_uitone2_control =
	SOC_DAPM_ENUM_EXT("VP UITONE2 MUX Mux", vp_uitone2_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum mm_primary_enum =
	SOC_ENUM_SINGLE(ES_PRIMARY_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_mm_pri_control =
	SOC_DAPM_ENUM_EXT("MM Pri MUX Mux", mm_primary_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum mm_secondary_enum =
	SOC_ENUM_SINGLE(ES_SECONDARY_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_mm_sec_control =
	SOC_DAPM_ENUM_EXT("MM Sec MUX Mux", mm_secondary_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum mm_audin1_enum =
	SOC_ENUM_SINGLE(ES_AUDIN1_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_mm_audin1_control =
	SOC_DAPM_ENUM_EXT("MM AUDIN1 MUX Mux", mm_audin1_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum mm_audin2_enum =
	SOC_ENUM_SINGLE(ES_AUDIN2_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_mm_audin2_control =
	SOC_DAPM_ENUM_EXT("MM AUDIN2 MUX Mux", mm_audin2_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum mm_uitone1_enum =
	SOC_ENUM_SINGLE(ES_UITONE1_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_mm_uitone1_control =
	SOC_DAPM_ENUM_EXT("MM UITONE1 MUX Mux", mm_uitone1_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum mm_uitone2_enum =
	SOC_ENUM_SINGLE(ES_UITONE2_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_mm_uitone2_control =
	SOC_DAPM_ENUM_EXT("MM UITONE2 MUX Mux", mm_uitone2_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum pass_audin1_enum =
	SOC_ENUM_SINGLE(ES_AUDIN1_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_pass_audin1_control =
	SOC_DAPM_ENUM_EXT("Pass AUDIN1 MUX Mux", pass_audin1_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum pass_audin2_enum =
	SOC_ENUM_SINGLE(ES_AUDIN2_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_pass_audin2_control =
	SOC_DAPM_ENUM_EXT("Pass AUDIN2 MUX Mux", pass_audin2_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum pass_audin3_enum =
	SOC_ENUM_SINGLE(ES_AUDIN3_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_pass_audin3_control =
	SOC_DAPM_ENUM_EXT("Pass AUDIN3 MUX Mux", pass_audin3_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum pass_audin4_enum =
	SOC_ENUM_SINGLE(ES_AUDIN4_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_pass_audin4_control =
	SOC_DAPM_ENUM_EXT("Pass AUDIN4 MUX Mux", pass_audin4_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum az_pri_enum =
	SOC_ENUM_SINGLE(ES_PRIMARY_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_az_pri_control =
	SOC_DAPM_ENUM_EXT("AudioZoom Primary MUX Mux", az_pri_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum az_sec_enum =
	SOC_ENUM_SINGLE(ES_SECONDARY_MUX, 0,
		     ARRAY_SIZE(proc_block_input_texts),
		     proc_block_input_texts);
static const struct snd_kcontrol_new dapm_az_sec_control =
	SOC_DAPM_ENUM_EXT("AudioZoom Secondary MUX Mux", az_sec_enum,
			  get_input_route_value, put_input_route_value);

static const struct soc_enum pcm0_0_enum =
	SOC_ENUM_SINGLE(ES_PCM0_0_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm0_0_control =
	SOC_DAPM_ENUM_EXT("PCM0.0 MUX Mux", pcm0_0_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm0_1_enum =
	SOC_ENUM_SINGLE(ES_PCM0_1_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm0_1_control =
	SOC_DAPM_ENUM_EXT("PCM0.1 MUX Mux", pcm0_1_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm0_2_enum =
	SOC_ENUM_SINGLE(ES_PCM0_2_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm0_2_control =
	SOC_DAPM_ENUM_EXT("PCM0.2 MUX Mux", pcm0_2_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm0_3_enum =
	SOC_ENUM_SINGLE(ES_PCM0_3_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm0_3_control =
	SOC_DAPM_ENUM_EXT("PCM0.3 MUX Mux", pcm0_0_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm1_0_enum =
	SOC_ENUM_SINGLE(ES_PCM1_0_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm1_0_control =
	SOC_DAPM_ENUM_EXT("PCM1.0 MUX Mux", pcm1_0_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm1_1_enum =
	SOC_ENUM_SINGLE(ES_PCM1_1_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm1_1_control =
	SOC_DAPM_ENUM_EXT("PCM1.1 MUX Mux", pcm1_1_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm1_2_enum =
	SOC_ENUM_SINGLE(ES_PCM1_2_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm1_2_control =
	SOC_DAPM_ENUM_EXT("PCM1.2 MUX Mux", pcm1_2_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm1_3_enum =
	SOC_ENUM_SINGLE(ES_PCM1_3_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm1_3_control =
	SOC_DAPM_ENUM_EXT("PCM1.3 MUX Mux", pcm1_3_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm2_0_enum =
	SOC_ENUM_SINGLE(ES_PCM2_0_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm2_0_control =
	SOC_DAPM_ENUM_EXT("PCM2.0 MUX Mux", pcm2_0_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm2_1_enum =
	SOC_ENUM_SINGLE(ES_PCM2_1_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm2_1_control =
	SOC_DAPM_ENUM_EXT("PCM2.1 MUX Mux", pcm2_1_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm2_2_enum =
	SOC_ENUM_SINGLE(ES_PCM2_2_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm2_2_control =
	SOC_DAPM_ENUM_EXT("PCM2.2 MUX Mux", pcm2_2_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum pcm2_3_enum =
	SOC_ENUM_SINGLE(ES_PCM2_3_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_pcm2_3_control =
	SOC_DAPM_ENUM_EXT("PCM2.3 MUX Mux", pcm2_3_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum sbustx0_enum =
	SOC_ENUM_SINGLE(ES_SBUSTX0_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_sbustx0_control =
	SOC_DAPM_ENUM_EXT("SBUS.TX0 MUX Mux", sbustx0_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum sbustx1_enum =
	SOC_ENUM_SINGLE(ES_SBUSTX1_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_sbustx1_control =
	SOC_DAPM_ENUM_EXT("SBUS.TX1 MUX Mux", sbustx1_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum sbustx2_enum =
	SOC_ENUM_SINGLE(ES_SBUSTX2_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_sbustx2_control =
	SOC_DAPM_ENUM_EXT("SBUS.TX2 MUX Mux", sbustx2_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum sbustx3_enum =
	SOC_ENUM_SINGLE(ES_SBUSTX3_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_sbustx3_control =
	SOC_DAPM_ENUM_EXT("SBUS.TX3 MUX Mux", sbustx3_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum sbustx4_enum =
	SOC_ENUM_SINGLE(ES_SBUSTX4_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_sbustx4_control =
	SOC_DAPM_ENUM_EXT("SBUS.TX4 MUX Mux", sbustx4_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum sbustx5_enum =
	SOC_ENUM_SINGLE(ES_SBUSTX5_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_sbustx5_control =
	SOC_DAPM_ENUM_EXT("SBUS.TX5 MUX Mux", sbustx5_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum dac0_0_enum =
	SOC_ENUM_SINGLE(ES_DAC0_0_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_dac0_0_control =
	SOC_DAPM_ENUM_EXT("DAC0.0 MUX Mux", dac0_0_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum dac0_1_enum =
	SOC_ENUM_SINGLE(ES_DAC0_1_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_dac0_1_control =
	SOC_DAPM_ENUM_EXT("DAC0.1 MUX Mux", dac0_1_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum dac1_0_enum =
	SOC_ENUM_SINGLE(ES_DAC1_0_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_dac1_0_control =
	SOC_DAPM_ENUM_EXT("DAC1.0 MUX Mux", dac1_0_enum,
			  get_output_route_value, put_output_route_value);

static const struct soc_enum dac1_1_enum =
	SOC_ENUM_SINGLE(ES_DAC1_1_MUX, 0,
		     ARRAY_SIZE(proc_block_output_texts),
		     proc_block_output_texts);
static const struct snd_kcontrol_new dapm_dac1_1_control =
	SOC_DAPM_ENUM_EXT("DAC1.1 MUX Mux", dac1_1_enum,
			  get_output_route_value, put_output_route_value);

static const struct snd_soc_dapm_widget es_d202_dapm_widgets[] = {

	/* AIF */
	SND_SOC_DAPM_AIF_IN("PCM0 RX", "PORTA Playback", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("PCM1 RX", "PORTB Playback", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("PCM2 RX", "PORTC Playback", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX0", "SLIM_PORT-1 Playback",
							0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX1", "SLIM_PORT-2 Playback",
							0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX2", "SLIM_PORT-3 Playback",
							0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX3", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX4", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX5", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX6", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX7", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX8", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_IN("SBUS.RX9", "", 0, SND_SOC_NOPM, 0, 0),

	SND_SOC_DAPM_AIF_OUT("PCM0 TX", "PORTA Capture", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("PCM1 TX", "PORTB Capture", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("PCM2 TX", "PORTC Capture", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("SBUS.TX0", "SLIM_PORT-1 Capture",
							0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("SBUS.TX1", "SLIM_PORT-2 Capture",
							0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("SBUS.TX2", "SLIM_PORT-3 Capture",
							0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("SBUS.TX3", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("SBUS.TX4", "", 0, SND_SOC_NOPM, 0, 0),
	SND_SOC_DAPM_AIF_OUT("SBUS.TX5", "", 0, SND_SOC_NOPM, 0, 0),

	/* voice processing */
	SND_SOC_DAPM_MUX("VP Primary MUX", SND_SOC_NOPM, 0, 0,
			&dapm_vp_pri_control),
	SND_SOC_DAPM_MUX("VP Secondary MUX", SND_SOC_NOPM, 0, 0,
			&dapm_vp_sec_control),
	SND_SOC_DAPM_MUX("VP Teritary MUX", SND_SOC_NOPM, 0, 0,
			&dapm_vp_ter_control),
	SND_SOC_DAPM_MUX("VP AECREF1 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_vp_aecref1_control),
	SND_SOC_DAPM_MUX("VP FEIN MUX", SND_SOC_NOPM, 0, 0,
			&dapm_vp_fein_control),
	SND_SOC_DAPM_MUX("VP UITONE1 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_vp_uitone1_control),
	SND_SOC_DAPM_MUX("VP UITONE2 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_vp_uitone2_control),
	/* multimedia */
	SND_SOC_DAPM_MUX("MM Primary MUX", SND_SOC_NOPM, 0, 0,
			&dapm_mm_pri_control),
	SND_SOC_DAPM_MUX("MM Secondary MUX", SND_SOC_NOPM, 0, 0,
			&dapm_mm_sec_control),
	SND_SOC_DAPM_MUX("MM AUDIN1 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_mm_audin1_control),
	SND_SOC_DAPM_MUX("MM AUDIN2 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_mm_audin2_control),
	SND_SOC_DAPM_MUX("MM UITONE1 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_mm_uitone1_control),
	SND_SOC_DAPM_MUX("MM UITONE2 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_mm_uitone2_control),
	/* pass through */
	SND_SOC_DAPM_MUX("Pass AUDIN1 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_pass_audin1_control),
	SND_SOC_DAPM_MUX("Pass AUDIN2 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_pass_audin2_control),
	SND_SOC_DAPM_MUX("Pass AUDIN3 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_pass_audin3_control),
	SND_SOC_DAPM_MUX("Pass AUDIN4 MUX", SND_SOC_NOPM, 0, 0,
			&dapm_pass_audin4_control),

	/* AudioZoom */
	SND_SOC_DAPM_MUX("AudioZoom Primary MUX", SND_SOC_NOPM, 0, 0,
			&dapm_az_pri_control),
	SND_SOC_DAPM_MUX("AudioZoom Secondary MUX", SND_SOC_NOPM, 0, 0,
			&dapm_az_sec_control),

	SND_SOC_DAPM_MUX("PCM0.0 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm0_0_control),
	SND_SOC_DAPM_MUX("PCM0.1 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm0_1_control),
	SND_SOC_DAPM_MUX("PCM0.2 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm0_2_control),
	SND_SOC_DAPM_MUX("PCM0.3 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm0_3_control),
	SND_SOC_DAPM_MUX("PCM1.0 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm1_0_control),
	SND_SOC_DAPM_MUX("PCM1.1 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm1_1_control),
	SND_SOC_DAPM_MUX("PCM1.2 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm1_2_control),
	SND_SOC_DAPM_MUX("PCM1.3 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm1_3_control),
	SND_SOC_DAPM_MUX("PCM2.0 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm2_0_control),
	SND_SOC_DAPM_MUX("PCM2.1 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm2_1_control),
	SND_SOC_DAPM_MUX("PCM2.2 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm2_2_control),
	SND_SOC_DAPM_MUX("PCM2.3 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_pcm2_3_control),
	SND_SOC_DAPM_MUX("SBUS.TX0 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_sbustx0_control),
	SND_SOC_DAPM_MUX("SBUS.TX1 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_sbustx1_control),
	SND_SOC_DAPM_MUX("SBUS.TX2 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_sbustx2_control),
	SND_SOC_DAPM_MUX("SBUS.TX3 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_sbustx3_control),
	SND_SOC_DAPM_MUX("SBUS.TX4 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_sbustx4_control),
	SND_SOC_DAPM_MUX("SBUS.TX5 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_sbustx5_control),
	SND_SOC_DAPM_MUX("DAC0.0 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_dac0_0_control),
	SND_SOC_DAPM_MUX("DAC0.1 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_dac0_1_control),
	SND_SOC_DAPM_MUX("DAC1.0 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_dac1_0_control),
	SND_SOC_DAPM_MUX("DAC1.1 MUX", SND_SOC_NOPM, 0, 0,
			 &dapm_dac1_1_control),
	SND_SOC_DAPM_MIXER("VP CSOUT Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("VP FEOUT1 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("VP FEOUT2 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("MM CSOUT Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("MM AUDOUT1 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("MM AUDOUT2 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("Pass AUDOUT1 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("Pass AUDOUT2 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("Pass AUDOUT3 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("Pass AUDOUT4 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
	SND_SOC_DAPM_MIXER("AudioZoom CSOUT Mixer", SND_SOC_NOPM,
			0, 0, NULL, 0),
};

static const struct snd_soc_dapm_route intercon[] = {


	{"VP Primary MUX", "PCM0.0", "PCM0 RX"},
	{"VP Primary MUX", "PCM0.1", "PCM0 RX"},
	{"VP Primary MUX", "PCM0.2", "PCM0 RX"},
	{"VP Primary MUX", "PCM0.3", "PCM0 RX"},
	{"VP Primary MUX", "PCM1.0", "PCM1 RX"},
	{"VP Primary MUX", "PCM1.1", "PCM1 RX"},
	{"VP Primary MUX", "PCM1.2", "PCM1 RX"},
	{"VP Primary MUX", "PCM1.3", "PCM1 RX"},
	{"VP Primary MUX", "PCM2.0", "PCM2 RX"},
	{"VP Primary MUX", "PCM2.1", "PCM2 RX"},
	{"VP Primary MUX", "PCM2.2", "PCM2 RX"},
	{"VP Primary MUX", "PCM2.3", "PCM2 RX"},
	{"VP Primary MUX", "SBUS.RX0", "SBUS.RX0"},
	{"VP Primary MUX", "SBUS.RX1", "SBUS.RX1"},
	{"VP Primary MUX", "SBUS.RX2", "SBUS.RX2"},
	{"VP Primary MUX", "SBUS.RX3", "SBUS.RX3"},
	{"VP Primary MUX", "SBUS.RX4", "SBUS.RX4"},
	{"VP Primary MUX", "SBUS.RX5", "SBUS.RX5"},
	{"VP Primary MUX", "SBUS.RX6", "SBUS.RX6"},
	{"VP Primary MUX", "SBUS.RX7", "SBUS.RX7"},
	{"VP Primary MUX", "SBUS.RX8", "SBUS.RX8"},
	{"VP Primary MUX", "SBUS.RX9", "SBUS.RX9"},
	{"VP Primary MUX", "ADC1", "ADC1"},
	{"VP Primary MUX", "ADC2", "ADC2"},
	{"VP Primary MUX", "ADC3", "ADC3"},

	{"VP Secondary MUX", "PCM0.0", "PCM0 RX"},
	{"VP Secondary MUX", "PCM0.1", "PCM0 RX"},
	{"VP Secondary MUX", "PCM0.2", "PCM0 RX"},
	{"VP Secondary MUX", "PCM0.3", "PCM0 RX"},
	{"VP Secondary MUX", "PCM1.0", "PCM1 RX"},
	{"VP Secondary MUX", "PCM1.1", "PCM1 RX"},
	{"VP Secondary MUX", "PCM1.2", "PCM1 RX"},
	{"VP Secondary MUX", "PCM1.3", "PCM1 RX"},
	{"VP Secondary MUX", "PCM2.0", "PCM2 RX"},
	{"VP Secondary MUX", "PCM2.1", "PCM2 RX"},
	{"VP Secondary MUX", "PCM2.2", "PCM2 RX"},
	{"VP Secondary MUX", "PCM2.3", "PCM2 RX"},
	{"VP Secondary MUX", "SBUS.RX0", "SBUS.RX0"},
	{"VP Secondary MUX", "SBUS.RX1", "SBUS.RX1"},
	{"VP Secondary MUX", "SBUS.RX2", "SBUS.RX2"},
	{"VP Secondary MUX", "SBUS.RX3", "SBUS.RX3"},
	{"VP Secondary MUX", "SBUS.RX4", "SBUS.RX4"},
	{"VP Secondary MUX", "SBUS.RX5", "SBUS.RX5"},
	{"VP Secondary MUX", "SBUS.RX6", "SBUS.RX6"},
	{"VP Secondary MUX", "SBUS.RX7", "SBUS.RX7"},
	{"VP Secondary MUX", "SBUS.RX8", "SBUS.RX8"},
	{"VP Secondary MUX", "SBUS.RX9", "SBUS.RX9"},
	{"VP Secondary MUX", "ADC1", "ADC1"},
	{"VP Secondary MUX", "ADC2", "ADC2"},
	{"VP Secondary MUX", "ADC3", "ADC3"},

	{"VP Teritary MUX", "PCM0.0", "PCM0 RX"},
	{"VP Teritary MUX", "PCM0.1", "PCM0 RX"},
	{"VP Teritary MUX", "PCM0.2", "PCM0 RX"},
	{"VP Teritary MUX", "PCM0.3", "PCM0 RX"},
	{"VP Teritary MUX", "PCM1.0", "PCM1 RX"},
	{"VP Teritary MUX", "PCM1.1", "PCM1 RX"},
	{"VP Teritary MUX", "PCM1.2", "PCM1 RX"},
	{"VP Teritary MUX", "PCM1.3", "PCM1 RX"},
	{"VP Teritary MUX", "PCM2.0", "PCM2 RX"},
	{"VP Teritary MUX", "PCM2.1", "PCM2 RX"},
	{"VP Teritary MUX", "PCM2.2", "PCM2 RX"},
	{"VP Teritary MUX", "PCM2.3", "PCM2 RX"},
	{"VP Teritary MUX", "SBUS.RX0", "SBUS.RX0"},
	{"VP Teritary MUX", "SBUS.RX1", "SBUS.RX1"},
	{"VP Teritary MUX", "SBUS.RX2", "SBUS.RX2"},
	{"VP Teritary MUX", "SBUS.RX3", "SBUS.RX3"},
	{"VP Teritary MUX", "SBUS.RX4", "SBUS.RX4"},
	{"VP Teritary MUX", "SBUS.RX5", "SBUS.RX5"},
	{"VP Teritary MUX", "SBUS.RX6", "SBUS.RX6"},
	{"VP Teritary MUX", "SBUS.RX7", "SBUS.RX7"},
	{"VP Teritary MUX", "SBUS.RX8", "SBUS.RX8"},
	{"VP Teritary MUX", "SBUS.RX9", "SBUS.RX9"},
	{"VP Teritary MUX", "ADC1", "ADC1"},
	{"VP Teritary MUX", "ADC2", "ADC2"},
	{"VP Teritary MUX", "ADC3", "ADC3"},

	{"VP FEIN MUX", "PCM0.0", "PCM0 RX"},
	{"VP FEIN MUX", "PCM0.1", "PCM0 RX"},
	{"VP FEIN MUX", "PCM0.2", "PCM0 RX"},
	{"VP FEIN MUX", "PCM0.3", "PCM0 RX"},
	{"VP FEIN MUX", "PCM1.0", "PCM1 RX"},
	{"VP FEIN MUX", "PCM1.1", "PCM1 RX"},
	{"VP FEIN MUX", "PCM1.2", "PCM1 RX"},
	{"VP FEIN MUX", "PCM1.3", "PCM1 RX"},
	{"VP FEIN MUX", "PCM2.0", "PCM2 RX"},
	{"VP FEIN MUX", "PCM2.1", "PCM2 RX"},
	{"VP FEIN MUX", "PCM2.2", "PCM2 RX"},
	{"VP FEIN MUX", "PCM2.3", "PCM2 RX"},
	{"VP FEIN MUX", "SBUS.RX0", "SBUS.RX0"},
	{"VP FEIN MUX", "SBUS.RX1", "SBUS.RX1"},
	{"VP FEIN MUX", "SBUS.RX2", "SBUS.RX2"},
	{"VP FEIN MUX", "SBUS.RX3", "SBUS.RX3"},
	{"VP FEIN MUX", "SBUS.RX4", "SBUS.RX4"},
	{"VP FEIN MUX", "SBUS.RX5", "SBUS.RX5"},
	{"VP FEIN MUX", "SBUS.RX6", "SBUS.RX6"},
	{"VP FEIN MUX", "SBUS.RX7", "SBUS.RX7"},
	{"VP FEIN MUX", "SBUS.RX8", "SBUS.RX8"},
	{"VP FEIN MUX", "SBUS.RX9", "SBUS.RX9"},
	{"VP FEIN MUX", "ADC1", "ADC1"},
	{"VP FEIN MUX", "ADC2", "ADC2"},
	{"VP FEIN MUX", "ADC3", "ADC3"},

	{"VP AECREF1 MUX", "PCM0.0", "PCM0 RX"},
	{"VP AECREF1 MUX", "PCM0.1", "PCM0 RX"},
	{"VP AECREF1 MUX", "PCM0.2", "PCM0 RX"},
	{"VP AECREF1 MUX", "PCM0.3", "PCM0 RX"},
	{"VP AECREF1 MUX", "PCM1.0", "PCM1 RX"},
	{"VP AECREF1 MUX", "PCM1.1", "PCM1 RX"},
	{"VP AECREF1 MUX", "PCM1.2", "PCM1 RX"},
	{"VP AECREF1 MUX", "PCM1.3", "PCM1 RX"},
	{"VP AECREF1 MUX", "PCM2.0", "PCM2 RX"},
	{"VP AECREF1 MUX", "PCM2.1", "PCM2 RX"},
	{"VP AECREF1 MUX", "PCM2.2", "PCM2 RX"},
	{"VP AECREF1 MUX", "PCM2.3", "PCM2 RX"},
	{"VP AECREF1 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"VP AECREF1 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"VP AECREF1 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"VP AECREF1 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"VP AECREF1 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"VP AECREF1 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"VP AECREF1 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"VP AECREF1 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"VP AECREF1 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"VP AECREF1 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"VP AECREF1 MUX", "ADC1", "ADC1"},
	{"VP AECREF1 MUX", "ADC2", "ADC2"},
	{"VP AECREF1 MUX", "ADC3", "ADC3"},

	{"VP UITONE1 MUX", "PCM0.0", "PCM0 RX"},
	{"VP UITONE1 MUX", "PCM0.1", "PCM0 RX"},
	{"VP UITONE1 MUX", "PCM0.2", "PCM0 RX"},
	{"VP UITONE1 MUX", "PCM0.3", "PCM0 RX"},
	{"VP UITONE1 MUX", "PCM1.0", "PCM1 RX"},
	{"VP UITONE1 MUX", "PCM1.1", "PCM1 RX"},
	{"VP UITONE1 MUX", "PCM1.2", "PCM1 RX"},
	{"VP UITONE1 MUX", "PCM1.3", "PCM1 RX"},
	{"VP UITONE1 MUX", "PCM2.0", "PCM2 RX"},
	{"VP UITONE1 MUX", "PCM2.1", "PCM2 RX"},
	{"VP UITONE1 MUX", "PCM2.2", "PCM2 RX"},
	{"VP UITONE1 MUX", "PCM2.3", "PCM2 RX"},
	{"VP UITONE1 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"VP UITONE1 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"VP UITONE1 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"VP UITONE1 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"VP UITONE1 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"VP UITONE1 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"VP UITONE1 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"VP UITONE1 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"VP UITONE1 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"VP UITONE1 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"VP UITONE1 MUX", "ADC1", "ADC1"},
	{"VP UITONE1 MUX", "ADC2", "ADC2"},
	{"VP UITONE1 MUX", "ADC3", "ADC3"},

	{"VP UITONE2 MUX", "PCM0.0", "PCM0 RX"},
	{"VP UITONE2 MUX", "PCM0.1", "PCM0 RX"},
	{"VP UITONE2 MUX", "PCM0.2", "PCM0 RX"},
	{"VP UITONE2 MUX", "PCM0.3", "PCM0 RX"},
	{"VP UITONE2 MUX", "PCM1.0", "PCM1 RX"},
	{"VP UITONE2 MUX", "PCM1.1", "PCM1 RX"},
	{"VP UITONE2 MUX", "PCM1.2", "PCM1 RX"},
	{"VP UITONE2 MUX", "PCM1.3", "PCM1 RX"},
	{"VP UITONE2 MUX", "PCM2.0", "PCM2 RX"},
	{"VP UITONE2 MUX", "PCM2.1", "PCM2 RX"},
	{"VP UITONE2 MUX", "PCM2.2", "PCM2 RX"},
	{"VP UITONE2 MUX", "PCM2.3", "PCM2 RX"},
	{"VP UITONE2 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"VP UITONE2 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"VP UITONE2 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"VP UITONE2 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"VP UITONE2 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"VP UITONE2 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"VP UITONE2 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"VP UITONE2 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"VP UITONE2 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"VP UITONE2 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"VP UITONE2 MUX", "ADC1", "ADC1"},
	{"VP UITONE2 MUX", "ADC2", "ADC2"},
	{"VP UITONE2 MUX", "ADC3", "ADC3"},

	{"VP CSOUT Mixer", NULL, "VP Primary MUX"},
	{"VP CSOUT Mixer", NULL, "VP Secondary MUX"},
	{"VP CSOUT Mixer", NULL, "VP Teritary MUX"},
	{"VP CSOUT Mixer", NULL, "VP AECREF1 MUX"},
	{"VP FEOUT1 Mixer", NULL, "VP FEIN MUX"},
	{"VP FEOUT1 Mixer", NULL, "VP UITONE1 MUX"},
	{"VP FEOUT1 Mixer", NULL, "VP UITONE2 MUX"},
	{"VP FEOUT2 Mixer", NULL, "VP FEIN MUX"},
	{"VP FEOUT2 Mixer", NULL, "VP UITONE1 MUX"},
	{"VP FEOUT2 Mixer", NULL, "VP UITONE2 MUX"},

	{"MM Primary MUX", "PCM0.0", "PCM0 RX"},
	{"MM Primary MUX", "PCM0.1", "PCM0 RX"},
	{"MM Primary MUX", "PCM0.2", "PCM0 RX"},
	{"MM Primary MUX", "PCM0.3", "PCM0 RX"},
	{"MM Primary MUX", "PCM1.0", "PCM1 RX"},
	{"MM Primary MUX", "PCM1.1", "PCM1 RX"},
	{"MM Primary MUX", "PCM1.2", "PCM1 RX"},
	{"MM Primary MUX", "PCM1.3", "PCM1 RX"},
	{"MM Primary MUX", "PCM2.0", "PCM2 RX"},
	{"MM Primary MUX", "PCM2.1", "PCM2 RX"},
	{"MM Primary MUX", "PCM2.2", "PCM2 RX"},
	{"MM Primary MUX", "PCM2.3", "PCM2 RX"},
	{"MM Primary MUX", "SBUS.RX0", "SBUS.RX0"},
	{"MM Primary MUX", "SBUS.RX1", "SBUS.RX1"},
	{"MM Primary MUX", "SBUS.RX2", "SBUS.RX2"},
	{"MM Primary MUX", "SBUS.RX3", "SBUS.RX3"},
	{"MM Primary MUX", "SBUS.RX4", "SBUS.RX4"},
	{"MM Primary MUX", "SBUS.RX5", "SBUS.RX5"},
	{"MM Primary MUX", "SBUS.RX6", "SBUS.RX6"},
	{"MM Primary MUX", "SBUS.RX7", "SBUS.RX7"},
	{"MM Primary MUX", "SBUS.RX8", "SBUS.RX8"},
	{"MM Primary MUX", "SBUS.RX9", "SBUS.RX9"},
	{"MM Primary MUX", "ADC1", "ADC1"},
	{"MM Primary MUX", "ADC2", "ADC2"},
	{"MM Primary MUX", "ADC3", "ADC3"},

	{"MM Secondary MUX", "PCM0.0", "PCM0 RX"},
	{"MM Secondary MUX", "PCM0.1", "PCM0 RX"},
	{"MM Secondary MUX", "PCM0.2", "PCM0 RX"},
	{"MM Secondary MUX", "PCM0.3", "PCM0 RX"},
	{"MM Secondary MUX", "PCM1.0", "PCM1 RX"},
	{"MM Secondary MUX", "PCM1.1", "PCM1 RX"},
	{"MM Secondary MUX", "PCM1.2", "PCM1 RX"},
	{"MM Secondary MUX", "PCM1.3", "PCM1 RX"},
	{"MM Secondary MUX", "PCM2.0", "PCM2 RX"},
	{"MM Secondary MUX", "PCM2.1", "PCM2 RX"},
	{"MM Secondary MUX", "PCM2.2", "PCM2 RX"},
	{"MM Secondary MUX", "PCM2.3", "PCM2 RX"},
	{"MM Secondary MUX", "SBUS.RX0", "SBUS.RX0"},
	{"MM Secondary MUX", "SBUS.RX1", "SBUS.RX1"},
	{"MM Secondary MUX", "SBUS.RX2", "SBUS.RX2"},
	{"MM Secondary MUX", "SBUS.RX3", "SBUS.RX3"},
	{"MM Secondary MUX", "SBUS.RX4", "SBUS.RX4"},
	{"MM Secondary MUX", "SBUS.RX5", "SBUS.RX5"},
	{"MM Secondary MUX", "SBUS.RX6", "SBUS.RX6"},
	{"MM Secondary MUX", "SBUS.RX7", "SBUS.RX7"},
	{"MM Secondary MUX", "SBUS.RX8", "SBUS.RX8"},
	{"MM Secondary MUX", "SBUS.RX9", "SBUS.RX9"},
	{"MM Secondary MUX", "ADC1", "ADC1"},
	{"MM Secondary MUX", "ADC2", "ADC2"},
	{"MM Secondary MUX", "ADC3", "ADC3"},

	{"MM AUDIN1 MUX", "PCM0.0", "PCM0 RX"},
	{"MM AUDIN1 MUX", "PCM0.1", "PCM0 RX"},
	{"MM AUDIN1 MUX", "PCM0.2", "PCM0 RX"},
	{"MM AUDIN1 MUX", "PCM0.3", "PCM0 RX"},
	{"MM AUDIN1 MUX", "PCM1.0", "PCM1 RX"},
	{"MM AUDIN1 MUX", "PCM1.1", "PCM1 RX"},
	{"MM AUDIN1 MUX", "PCM1.2", "PCM1 RX"},
	{"MM AUDIN1 MUX", "PCM1.3", "PCM1 RX"},
	{"MM AUDIN1 MUX", "PCM2.0", "PCM2 RX"},
	{"MM AUDIN1 MUX", "PCM2.1", "PCM2 RX"},
	{"MM AUDIN1 MUX", "PCM2.2", "PCM2 RX"},
	{"MM AUDIN1 MUX", "PCM2.3", "PCM2 RX"},
	{"MM AUDIN1 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"MM AUDIN1 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"MM AUDIN1 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"MM AUDIN1 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"MM AUDIN1 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"MM AUDIN1 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"MM AUDIN1 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"MM AUDIN1 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"MM AUDIN1 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"MM AUDIN1 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"MM AUDIN1 MUX", "ADC1", "ADC1"},
	{"MM AUDIN1 MUX", "ADC2", "ADC2"},
	{"MM AUDIN1 MUX", "ADC3", "ADC3"},

	{"MM AUDIN2 MUX", "PCM0.0", "PCM0 RX"},
	{"MM AUDIN2 MUX", "PCM0.1", "PCM0 RX"},
	{"MM AUDIN2 MUX", "PCM0.2", "PCM0 RX"},
	{"MM AUDIN2 MUX", "PCM0.3", "PCM0 RX"},
	{"MM AUDIN2 MUX", "PCM1.0", "PCM1 RX"},
	{"MM AUDIN2 MUX", "PCM1.1", "PCM1 RX"},
	{"MM AUDIN2 MUX", "PCM1.2", "PCM1 RX"},
	{"MM AUDIN2 MUX", "PCM1.3", "PCM1 RX"},
	{"MM AUDIN2 MUX", "PCM2.0", "PCM2 RX"},
	{"MM AUDIN2 MUX", "PCM2.1", "PCM2 RX"},
	{"MM AUDIN2 MUX", "PCM2.2", "PCM2 RX"},
	{"MM AUDIN2 MUX", "PCM2.3", "PCM2 RX"},
	{"MM AUDIN2 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"MM AUDIN2 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"MM AUDIN2 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"MM AUDIN2 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"MM AUDIN2 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"MM AUDIN2 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"MM AUDIN2 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"MM AUDIN2 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"MM AUDIN2 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"MM AUDIN2 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"MM AUDIN2 MUX", "ADC1", "ADC1"},
	{"MM AUDIN2 MUX", "ADC2", "ADC2"},
	{"MM AUDIN2 MUX", "ADC3", "ADC3"},

	{"MM UITONE1 MUX", "PCM0.0", "PCM0 RX"},
	{"MM UITONE1 MUX", "PCM0.1", "PCM0 RX"},
	{"MM UITONE1 MUX", "PCM0.2", "PCM0 RX"},
	{"MM UITONE1 MUX", "PCM0.3", "PCM0 RX"},
	{"MM UITONE1 MUX", "PCM1.0", "PCM1 RX"},
	{"MM UITONE1 MUX", "PCM1.1", "PCM1 RX"},
	{"MM UITONE1 MUX", "PCM1.2", "PCM1 RX"},
	{"MM UITONE1 MUX", "PCM1.3", "PCM1 RX"},
	{"MM UITONE1 MUX", "PCM2.0", "PCM2 RX"},
	{"MM UITONE1 MUX", "PCM2.1", "PCM2 RX"},
	{"MM UITONE1 MUX", "PCM2.2", "PCM2 RX"},
	{"MM UITONE1 MUX", "PCM2.3", "PCM2 RX"},
	{"MM UITONE1 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"MM UITONE1 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"MM UITONE1 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"MM UITONE1 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"MM UITONE1 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"MM UITONE1 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"MM UITONE1 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"MM UITONE1 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"MM UITONE1 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"MM UITONE1 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"MM UITONE1 MUX", "ADC1", "ADC1"},
	{"MM UITONE1 MUX", "ADC2", "ADC2"},
	{"MM UITONE1 MUX", "ADC3", "ADC3"},

	{"MM UITONE2 MUX", "PCM0.0", "PCM0 RX"},
	{"MM UITONE2 MUX", "PCM0.1", "PCM0 RX"},
	{"MM UITONE2 MUX", "PCM0.2", "PCM0 RX"},
	{"MM UITONE2 MUX", "PCM0.3", "PCM0 RX"},
	{"MM UITONE2 MUX", "PCM1.0", "PCM1 RX"},
	{"MM UITONE2 MUX", "PCM1.1", "PCM1 RX"},
	{"MM UITONE2 MUX", "PCM1.2", "PCM1 RX"},
	{"MM UITONE2 MUX", "PCM1.3", "PCM1 RX"},
	{"MM UITONE2 MUX", "PCM2.0", "PCM2 RX"},
	{"MM UITONE2 MUX", "PCM2.1", "PCM2 RX"},
	{"MM UITONE2 MUX", "PCM2.2", "PCM2 RX"},
	{"MM UITONE2 MUX", "PCM2.3", "PCM2 RX"},
	{"MM UITONE2 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"MM UITONE2 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"MM UITONE2 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"MM UITONE2 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"MM UITONE2 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"MM UITONE2 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"MM UITONE2 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"MM UITONE2 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"MM UITONE2 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"MM UITONE2 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"MM UITONE2 MUX", "ADC1", "ADC1"},
	{"MM UITONE2 MUX", "ADC2", "ADC2"},
	{"MM UITONE2 MUX", "ADC3", "ADC3"},

	{"MM CSOUT Mixer", NULL, "MM Primary MUX"},
	{"MM CSOUT Mixer", NULL, "MM Secondary MUX"},
	{"MM AUDOUT1 Mixer", NULL, "MM AUDIN1 MUX"},
	{"MM AUDOUT1 Mixer", NULL, "MM UITONE1 MUX"},
	{"MM AUDOUT1 Mixer", NULL, "MM UITONE2 MUX"},
	{"MM AUDOUT2 Mixer", NULL, "MM AUDIN2 MUX"},
	{"MM AUDOUT2 Mixer", NULL, "MM UITONE1 MUX"},
	{"MM AUDOUT2 Mixer", NULL, "MM UITONE2 MUX"},

	{"Pass AUDIN1 MUX", "PCM0.0", "PCM0 RX"},
	{"Pass AUDIN1 MUX", "PCM0.1", "PCM0 RX"},
	{"Pass AUDIN1 MUX", "PCM0.2", "PCM0 RX"},
	{"Pass AUDIN1 MUX", "PCM0.3", "PCM0 RX"},
	{"Pass AUDIN1 MUX", "PCM1.0", "PCM1 RX"},
	{"Pass AUDIN1 MUX", "PCM1.1", "PCM1 RX"},
	{"Pass AUDIN1 MUX", "PCM1.2", "PCM1 RX"},
	{"Pass AUDIN1 MUX", "PCM1.3", "PCM1 RX"},
	{"Pass AUDIN1 MUX", "PCM2.0", "PCM2 RX"},
	{"Pass AUDIN1 MUX", "PCM2.1", "PCM2 RX"},
	{"Pass AUDIN1 MUX", "PCM2.2", "PCM2 RX"},
	{"Pass AUDIN1 MUX", "PCM2.3", "PCM2 RX"},
	{"Pass AUDIN1 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"Pass AUDIN1 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"Pass AUDIN1 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"Pass AUDIN1 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"Pass AUDIN1 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"Pass AUDIN1 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"Pass AUDIN1 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"Pass AUDIN1 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"Pass AUDIN1 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"Pass AUDIN1 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"Pass AUDIN1 MUX", "ADC1", "ADC1"},
	{"Pass AUDIN1 MUX", "ADC2", "ADC2"},
	{"Pass AUDIN1 MUX", "ADC3", "ADC3"},

	{"Pass AUDIN2 MUX", "PCM0.0", "PCM0 RX"},
	{"Pass AUDIN2 MUX", "PCM0.1", "PCM0 RX"},
	{"Pass AUDIN2 MUX", "PCM0.2", "PCM0 RX"},
	{"Pass AUDIN2 MUX", "PCM0.3", "PCM0 RX"},
	{"Pass AUDIN2 MUX", "PCM1.0", "PCM1 RX"},
	{"Pass AUDIN2 MUX", "PCM1.1", "PCM1 RX"},
	{"Pass AUDIN2 MUX", "PCM1.2", "PCM1 RX"},
	{"Pass AUDIN2 MUX", "PCM1.3", "PCM1 RX"},
	{"Pass AUDIN2 MUX", "PCM2.0", "PCM2 RX"},
	{"Pass AUDIN2 MUX", "PCM2.1", "PCM2 RX"},
	{"Pass AUDIN2 MUX", "PCM2.2", "PCM2 RX"},
	{"Pass AUDIN2 MUX", "PCM2.3", "PCM2 RX"},
	{"Pass AUDIN2 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"Pass AUDIN2 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"Pass AUDIN2 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"Pass AUDIN2 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"Pass AUDIN2 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"Pass AUDIN2 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"Pass AUDIN2 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"Pass AUDIN2 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"Pass AUDIN2 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"Pass AUDIN2 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"Pass AUDIN2 MUX", "ADC1", "ADC1"},
	{"Pass AUDIN2 MUX", "ADC2", "ADC2"},
	{"Pass AUDIN2 MUX", "ADC3", "ADC3"},

	{"Pass AUDIN3 MUX", "PCM0.0", "PCM0 RX"},
	{"Pass AUDIN3 MUX", "PCM0.1", "PCM0 RX"},
	{"Pass AUDIN3 MUX", "PCM0.2", "PCM0 RX"},
	{"Pass AUDIN3 MUX", "PCM0.3", "PCM0 RX"},
	{"Pass AUDIN3 MUX", "PCM1.0", "PCM1 RX"},
	{"Pass AUDIN3 MUX", "PCM1.1", "PCM1 RX"},
	{"Pass AUDIN3 MUX", "PCM1.2", "PCM1 RX"},
	{"Pass AUDIN3 MUX", "PCM1.3", "PCM1 RX"},
	{"Pass AUDIN3 MUX", "PCM2.0", "PCM2 RX"},
	{"Pass AUDIN3 MUX", "PCM2.1", "PCM2 RX"},
	{"Pass AUDIN3 MUX", "PCM2.2", "PCM2 RX"},
	{"Pass AUDIN3 MUX", "PCM2.3", "PCM2 RX"},
	{"Pass AUDIN3 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"Pass AUDIN3 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"Pass AUDIN3 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"Pass AUDIN3 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"Pass AUDIN3 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"Pass AUDIN3 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"Pass AUDIN3 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"Pass AUDIN3 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"Pass AUDIN3 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"Pass AUDIN3 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"Pass AUDIN3 MUX", "ADC1", "ADC1"},
	{"Pass AUDIN3 MUX", "ADC2", "ADC2"},
	{"Pass AUDIN3 MUX", "ADC3", "ADC3"},

	{"Pass AUDIN4 MUX", "PCM0.0", "PCM0 RX"},
	{"Pass AUDIN4 MUX", "PCM0.1", "PCM0 RX"},
	{"Pass AUDIN4 MUX", "PCM0.2", "PCM0 RX"},
	{"Pass AUDIN4 MUX", "PCM0.3", "PCM0 RX"},
	{"Pass AUDIN4 MUX", "PCM1.0", "PCM1 RX"},
	{"Pass AUDIN4 MUX", "PCM1.1", "PCM1 RX"},
	{"Pass AUDIN4 MUX", "PCM1.2", "PCM1 RX"},
	{"Pass AUDIN4 MUX", "PCM1.3", "PCM1 RX"},
	{"Pass AUDIN4 MUX", "PCM2.0", "PCM2 RX"},
	{"Pass AUDIN4 MUX", "PCM2.1", "PCM2 RX"},
	{"Pass AUDIN4 MUX", "PCM2.2", "PCM2 RX"},
	{"Pass AUDIN4 MUX", "PCM2.3", "PCM2 RX"},
	{"Pass AUDIN4 MUX", "SBUS.RX0", "SBUS.RX0"},
	{"Pass AUDIN4 MUX", "SBUS.RX1", "SBUS.RX1"},
	{"Pass AUDIN4 MUX", "SBUS.RX2", "SBUS.RX2"},
	{"Pass AUDIN4 MUX", "SBUS.RX3", "SBUS.RX3"},
	{"Pass AUDIN4 MUX", "SBUS.RX4", "SBUS.RX4"},
	{"Pass AUDIN4 MUX", "SBUS.RX5", "SBUS.RX5"},
	{"Pass AUDIN4 MUX", "SBUS.RX6", "SBUS.RX6"},
	{"Pass AUDIN4 MUX", "SBUS.RX7", "SBUS.RX7"},
	{"Pass AUDIN4 MUX", "SBUS.RX8", "SBUS.RX8"},
	{"Pass AUDIN4 MUX", "SBUS.RX9", "SBUS.RX9"},
	{"Pass AUDIN4 MUX", "ADC1", "ADC1"},
	{"Pass AUDIN4 MUX", "ADC2", "ADC2"},
	{"Pass AUDIN4 MUX", "ADC3", "ADC3"},

	{"Pass AUDOUT1 Mixer", NULL, "Pass AUDIN1 MUX"},
	{"Pass AUDOUT2 Mixer", NULL, "Pass AUDIN2 MUX"},
	{"Pass AUDOUT3 Mixer", NULL, "Pass AUDIN3 MUX"},
	{"Pass AUDOUT4 Mixer", NULL, "Pass AUDIN4 MUX"},

	{"AudioZoom Primary MUX", "PCM0.0", "PCM0 RX"},
	{"AudioZoom Primary MUX", "PCM0.1", "PCM0 RX"},
	{"AudioZoom Primary MUX", "PCM0.2", "PCM0 RX"},
	{"AudioZoom Primary MUX", "PCM0.3", "PCM0 RX"},
	{"AudioZoom Primary MUX", "PCM1.0", "PCM1 RX"},
	{"AudioZoom Primary MUX", "PCM1.1", "PCM1 RX"},
	{"AudioZoom Primary MUX", "PCM1.2", "PCM1 RX"},
	{"AudioZoom Primary MUX", "PCM1.3", "PCM1 RX"},
	{"AudioZoom Primary MUX", "PCM2.0", "PCM2 RX"},
	{"AudioZoom Primary MUX", "PCM2.1", "PCM2 RX"},
	{"AudioZoom Primary MUX", "PCM2.2", "PCM2 RX"},
	{"AudioZoom Primary MUX", "PCM2.3", "PCM2 RX"},
	{"AudioZoom Primary MUX", "SBUS.RX0", "SBUS.RX0"},
	{"AudioZoom Primary MUX", "SBUS.RX1", "SBUS.RX1"},
	{"AudioZoom Primary MUX", "SBUS.RX2", "SBUS.RX2"},
	{"AudioZoom Primary MUX", "SBUS.RX3", "SBUS.RX3"},
	{"AudioZoom Primary MUX", "SBUS.RX4", "SBUS.RX4"},
	{"AudioZoom Primary MUX", "SBUS.RX5", "SBUS.RX5"},
	{"AudioZoom Primary MUX", "SBUS.RX6", "SBUS.RX6"},
	{"AudioZoom Primary MUX", "SBUS.RX7", "SBUS.RX7"},
	{"AudioZoom Primary MUX", "SBUS.RX8", "SBUS.RX8"},
	{"AudioZoom Primary MUX", "SBUS.RX9", "SBUS.RX9"},
	{"AudioZoom Primary MUX", "ADC1", "ADC1"},
	{"AudioZoom Primary MUX", "ADC2", "ADC2"},
	{"AudioZoom Primary MUX", "ADC3", "ADC3"},

	{"AudioZoom Secondary MUX", "PCM0.0", "PCM0 RX"},
	{"AudioZoom Secondary MUX", "PCM0.1", "PCM0 RX"},
	{"AudioZoom Secondary MUX", "PCM0.2", "PCM0 RX"},
	{"AudioZoom Secondary MUX", "PCM0.3", "PCM0 RX"},
	{"AudioZoom Secondary MUX", "PCM1.0", "PCM1 RX"},
	{"AudioZoom Secondary MUX", "PCM1.1", "PCM1 RX"},
	{"AudioZoom Secondary MUX", "PCM1.2", "PCM1 RX"},
	{"AudioZoom Secondary MUX", "PCM1.3", "PCM1 RX"},
	{"AudioZoom Secondary MUX", "PCM2.0", "PCM2 RX"},
	{"AudioZoom Secondary MUX", "PCM2.1", "PCM2 RX"},
	{"AudioZoom Secondary MUX", "PCM2.2", "PCM2 RX"},
	{"AudioZoom Secondary MUX", "PCM2.3", "PCM2 RX"},
	{"AudioZoom Secondary MUX", "SBUS.RX0", "SBUS.RX0"},
	{"AudioZoom Secondary MUX", "SBUS.RX1", "SBUS.RX1"},
	{"AudioZoom Secondary MUX", "SBUS.RX2", "SBUS.RX2"},
	{"AudioZoom Secondary MUX", "SBUS.RX3", "SBUS.RX3"},
	{"AudioZoom Secondary MUX", "SBUS.RX4", "SBUS.RX4"},
	{"AudioZoom Secondary MUX", "SBUS.RX5", "SBUS.RX5"},
	{"AudioZoom Secondary MUX", "SBUS.RX6", "SBUS.RX6"},
	{"AudioZoom Secondary MUX", "SBUS.RX7", "SBUS.RX7"},
	{"AudioZoom Secondary MUX", "SBUS.RX8", "SBUS.RX8"},
	{"AudioZoom Secondary MUX", "SBUS.RX9", "SBUS.RX9"},
	{"AudioZoom Secondary MUX", "ADC1", "ADC1"},
	{"AudioZoom Secondary MUX", "ADC2", "ADC2"},
	{"AudioZoom Secondary MUX", "ADC3", "ADC3"},

	{"AudioZoom CSOUT Mixer", NULL, "AudioZoom Primary MUX"},
	{"AudioZoom CSOUT Mixer", NULL, "AudioZoom Primary MUX"},

	{"PCM0.0 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM0.0 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM0.0 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM0.0 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM0.0 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM0.0 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM0.0 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM0.0 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM0.0 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM0.0 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM0.0 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM0.1 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM0.1 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM0.1 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM0.1 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM0.1 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM0.1 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM0.1 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM0.1 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM0.1 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM0.1 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM0.1 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM0.2 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM0.2 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM0.2 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM0.2 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM0.2 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM0.2 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM0.2 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM0.2 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM0.2 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM0.2 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM0.2 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM0.3 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM0.3 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM0.3 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM0.3 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM0.3 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM0.3 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM0.3 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM0.3 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM0.3 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM0.3 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM0.3 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},

	{"PCM1.0 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM1.0 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM1.0 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM1.0 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM1.0 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM1.0 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM1.0 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM1.0 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM1.0 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM1.0 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM1.0 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM1.1 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM1.1 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM1.1 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM1.1 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM1.1 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM1.1 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM1.1 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM1.1 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM1.1 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM1.1 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM1.1 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM1.2 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM1.2 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM1.2 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM1.2 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM1.2 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM1.2 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM1.2 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM1.2 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM1.2 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM1.2 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM1.2 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM1.3 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM1.3 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM1.3 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM1.3 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM1.3 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM1.3 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM1.3 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM1.3 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM1.3 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM1.3 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM1.3 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},

	{"PCM2.0 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM2.0 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM2.0 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM2.0 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM2.0 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM2.0 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM2.0 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM2.0 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM2.0 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM2.0 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM2.0 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM2.1 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM2.1 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM2.1 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM2.1 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM2.1 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM2.1 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM2.1 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM2.1 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM2.1 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM2.1 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM2.1 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM2.2 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM2.2 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM2.2 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM2.2 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM2.2 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM2.2 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM2.2 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM2.2 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM2.2 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM2.2 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM2.2 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"PCM2.3 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"PCM2.3 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"PCM2.3 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"PCM2.3 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"PCM2.3 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"PCM2.3 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"PCM2.3 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"PCM2.3 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"PCM2.3 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"PCM2.3 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"PCM2.3 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},

	{"SBUS.TX0 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"SBUS.TX0 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"SBUS.TX0 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"SBUS.TX0 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"SBUS.TX0 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"SBUS.TX0 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"SBUS.TX0 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"SBUS.TX0 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"SBUS.TX0 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"SBUS.TX0 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"SBUS.TX0 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"SBUS.TX1 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"SBUS.TX1 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"SBUS.TX1 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"SBUS.TX1 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"SBUS.TX1 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"SBUS.TX1 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"SBUS.TX1 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"SBUS.TX1 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"SBUS.TX1 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"SBUS.TX1 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"SBUS.TX1 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"SBUS.TX2 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"SBUS.TX2 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"SBUS.TX2 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"SBUS.TX2 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"SBUS.TX2 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"SBUS.TX2 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"SBUS.TX2 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"SBUS.TX2 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"SBUS.TX2 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"SBUS.TX2 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"SBUS.TX2 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"SBUS.TX3 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"SBUS.TX3 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"SBUS.TX3 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"SBUS.TX3 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"SBUS.TX3 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"SBUS.TX3 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"SBUS.TX3 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"SBUS.TX3 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"SBUS.TX3 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"SBUS.TX3 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"SBUS.TX3 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"SBUS.TX4 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"SBUS.TX4 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"SBUS.TX4 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"SBUS.TX4 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"SBUS.TX4 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"SBUS.TX4 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"SBUS.TX4 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"SBUS.TX4 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"SBUS.TX4 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"SBUS.TX4 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"SBUS.TX4 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"SBUS.TX5 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"SBUS.TX5 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"SBUS.TX5 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"SBUS.TX5 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"SBUS.TX5 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"SBUS.TX5 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"SBUS.TX5 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"SBUS.TX5 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"SBUS.TX5 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"SBUS.TX5 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"SBUS.TX5 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},

	{"DAC0.0 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"DAC0.0 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"DAC0.0 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"DAC0.0 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"DAC0.0 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"DAC0.0 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"DAC0.0 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"DAC0.0 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"DAC0.0 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"DAC0.0 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"DAC0.0 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"DAC0.1 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"DAC0.1 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"DAC0.1 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"DAC0.1 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"DAC0.1 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"DAC0.1 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"DAC0.1 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"DAC0.1 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"DAC0.1 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"DAC0.1 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"DAC0.1 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"DAC1.0 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"DAC1.0 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"DAC1.0 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"DAC1.0 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"DAC1.0 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"DAC1.0 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"DAC1.0 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"DAC1.0 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"DAC1.0 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"DAC1.0 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"DAC1.0 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},
	{"DAC1.1 MUX", "VP CSOUT", "VP CSOUT Mixer"},
	{"DAC1.1 MUX", "VP FEOUT1", "VP FEOUT1 Mixer"},
	{"DAC1.1 MUX", "VP FEOUT2", "VP FEOUT2 Mixer"},
	{"DAC1.1 MUX", "AudioZoom CSOUT", "AudioZoom CSOUT Mixer"},
	{"DAC1.1 MUX", "MM CSOUT", "MM CSOUT Mixer"},
	{"DAC1.1 MUX", "MM AUDOUT1", "MM AUDOUT1 Mixer"},
	{"DAC1.1 MUX", "MM AUDOUT2", "MM AUDOUT2 Mixer"},
	{"DAC1.1 MUX", "Pass AUDOUT1", "Pass AUDOUT1 Mixer"},
	{"DAC1.1 MUX", "Pass AUDOUT2", "Pass AUDOUT2 Mixer"},
	{"DAC1.1 MUX", "Pass AUDOUT3", "Pass AUDOUT3 Mixer"},
	{"DAC1.1 MUX", "Pass AUDOUT4", "Pass AUDOUT4 Mixer"},

	/* AIF TX <--> PCM PORTA  */

	{"PCM0 TX", NULL, "PCM0.0 MUX"},
	{"PCM0 TX", NULL, "PCM0.1 MUX"},
	{"PCM0 TX", NULL, "PCM0.2 MUX"},
	{"PCM0 TX", NULL, "PCM0.3 MUX"},

	/* AIF TX <--> PCM PORTB  */

	{"PCM1 TX", NULL, "PCM1.0 MUX"},
	{"PCM1 TX", NULL, "PCM1.1 MUX"},
	{"PCM1 TX", NULL, "PCM1.2 MUX"},
	{"PCM1 TX", NULL, "PCM1.3 MUX"},

	/* AIF TX <--> PCM PORTC  */

	{"PCM2 TX", NULL, "PCM2.0 MUX"},
	{"PCM2 TX", NULL, "PCM2.1 MUX"},
	{"PCM2 TX", NULL, "PCM2.2 MUX"},
	{"PCM2 TX", NULL, "PCM2.3 MUX"},

	/* A212 DAC <--> D202 RX  */

	{"DAC1L", NULL, "DAC0.0 MUX"},
	{"DAC1R", NULL, "DAC0.1 MUX"},
	{"DAC2L", NULL, "DAC1.0 MUX"},
	{"DAC2R", NULL, "DAC1.1 MUX"},
};

void es_d202_fill_cmdcache(struct snd_soc_codec *codec)
{
	unsigned int reg;
	/*unsigned int value;*/

	for (reg = ES_MIC_CONFIG ; reg < ES_API_ADDR_MAX ; reg++) {
		/* Disable until reading digital registers is fixed */
		/* value = escore_read(codec, reg); */
		cachedcmd_list[reg] = 0;
	}
}
EXPORT_SYMBOL_GPL(es_d202_fill_cmdcache);

int es_d202_add_snd_soc_controls(struct snd_soc_codec *codec)
{
	int rc;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 4, 0)
	rc = snd_soc_add_codec_controls(codec, es_d202_snd_controls,
			ARRAY_SIZE(es_d202_snd_controls));
#else
	rc = snd_soc_add_controls(codec, es_d202_snd_controls,
			ARRAY_SIZE(es_d202_snd_controls));
#endif

	return rc;
}

int es_d202_add_snd_soc_dapm_controls(struct snd_soc_codec *codec)
{
	int rc;

	rc = snd_soc_dapm_new_controls(&codec->dapm, es_d202_dapm_widgets,
			ARRAY_SIZE(es_d202_dapm_widgets));

	return rc;
}

int es_d202_add_snd_soc_route_map(struct snd_soc_codec *codec)
{
	int rc;

	rc = snd_soc_dapm_add_routes(&codec->dapm, intercon,
			ARRAY_SIZE(intercon));

	return rc;
}

int es_d202_probe(struct snd_soc_codec *codec)
{
	int rc = 0;
	rc = es_d202_add_snd_soc_controls(codec);
	if (rc) {
		dev_err(codec->dev,
			"%s(): es_d202_snd_controls failed\n", __func__);
		return rc;
	}
	rc = es_d202_add_snd_soc_dapm_controls(codec);
	if (rc) {
		dev_err(codec->dev,
			"%s(): es_d202_dapm_widgets failed\n", __func__);
		return rc;
	}
	rc = snd_soc_dapm_add_routes(&codec->dapm, intercon,
			ARRAY_SIZE(intercon));
	if (rc) {
		dev_err(codec->dev,
			"%s(): es_d202_add_routes failed\n", __func__);
		return rc;
	}

	return rc;
}
EXPORT_SYMBOL_GPL(es_d202_probe);

.class Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;
.super Lcom/android/internal/util/State;
.source "WifiWatchdogStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/net/wifi/WifiWatchdogStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "LinkMonitoringState"
.end annotation


# instance fields
.field private mLastRssi:I

.field private mLastTxBad:I

.field private mLastTxGood:I

.field private mSampleCount:I

.field final synthetic this$0:Landroid/net/wifi/WifiWatchdogStateMachine;


# direct methods
.method constructor <init>(Landroid/net/wifi/WifiWatchdogStateMachine;)V
    .locals 0
    .parameter

    .prologue
    .line 765
    iput-object p1, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    invoke-direct {p0}, Lcom/android/internal/util/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 6

    .prologue
    const/4 v5, 0x0

    .line 775
    iget-object v0, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    invoke-virtual {p0}, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->getName()Ljava/lang/String;

    move-result-object v1

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->logd(Ljava/lang/String;)V
    invoke-static {v0, v1}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5200(Landroid/net/wifi/WifiWatchdogStateMachine;Ljava/lang/String;)V

    .line 776
    iput v5, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mSampleCount:I

    .line 777
    iget-object v0, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    new-instance v1, Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;

    iget-object v2, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    const-wide/high16 v3, 0x3fe0

    invoke-direct {v1, v2, v3, v4}, Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;-><init>(Landroid/net/wifi/WifiWatchdogStateMachine;D)V

    #setter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentLoss:Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;
    invoke-static {v0, v1}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5302(Landroid/net/wifi/WifiWatchdogStateMachine;Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;)Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;

    .line 778
    iget-object v0, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    iget-object v1, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    const v2, 0x2100b

    iget-object v3, p0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    invoke-static {v3}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$3304(Landroid/net/wifi/WifiWatchdogStateMachine;)I

    move-result v3

    invoke-virtual {v1, v2, v3, v5}, Landroid/net/wifi/WifiWatchdogStateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/net/wifi/WifiWatchdogStateMachine;->sendMessage(Landroid/os/Message;)V

    .line 779
    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 21
    .parameter "msg"

    .prologue
    .line 783
    move-object/from16 v0, p1

    iget v15, v0, Landroid/os/Message;->what:I

    sparse-switch v15, :sswitch_data_0

    .line 867
    const/4 v15, 0x0

    .line 869
    :goto_0
    return v15

    .line 785
    :sswitch_0
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v16, v0

    move-object/from16 v0, p1

    iget v0, v0, Landroid/os/Message;->arg1:I

    move/from16 v17, v0

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->calculateSignalLevel(I)I
    invoke-static/range {v16 .. v17}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$400(Landroid/net/wifi/WifiWatchdogStateMachine;I)I

    move-result v16

    #setter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentSignalLevel:I
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$302(Landroid/net/wifi/WifiWatchdogStateMachine;I)I

    .line 786
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentSignalLevel:I
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$300(Landroid/net/wifi/WifiWatchdogStateMachine;)I

    move-result v15

    const/16 v16, 0x4

    move/from16 v0, v16

    if-gt v15, v0, :cond_1

    .line 869
    :cond_0
    :goto_1
    const/4 v15, 0x1

    goto :goto_0

    .line 790
    :cond_1
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v16, v0

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mOnlineWatchState:Landroid/net/wifi/WifiWatchdogStateMachine$OnlineWatchState;
    invoke-static/range {v16 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$2600(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$OnlineWatchState;

    move-result-object v16

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->transitionTo(Lcom/android/internal/util/IState;)V
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5400(Landroid/net/wifi/WifiWatchdogStateMachine;Lcom/android/internal/util/IState;)V

    goto :goto_1

    .line 795
    :sswitch_1
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v16, v0

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mLinkMonitoringState:Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;
    invoke-static/range {v16 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5000(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;

    move-result-object v16

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->transitionTo(Lcom/android/internal/util/IState;)V
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5500(Landroid/net/wifi/WifiWatchdogStateMachine;Lcom/android/internal/util/IState;)V

    goto :goto_1

    .line 799
    :sswitch_2
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mIsScreenOn:Z
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$500(Landroid/net/wifi/WifiWatchdogStateMachine;)Z

    move-result v15

    if-nez v15, :cond_2

    .line 800
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v16, v0

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mOnlineState:Landroid/net/wifi/WifiWatchdogStateMachine$OnlineState;
    invoke-static/range {v16 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$4600(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$OnlineState;

    move-result-object v16

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->transitionTo(Lcom/android/internal/util/IState;)V
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5600(Landroid/net/wifi/WifiWatchdogStateMachine;Lcom/android/internal/util/IState;)V

    goto :goto_1

    .line 801
    :cond_2
    move-object/from16 v0, p1

    iget v15, v0, Landroid/os/Message;->arg1:I

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v16, v0

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mRssiFetchToken:I
    invoke-static/range {v16 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$3300(Landroid/net/wifi/WifiWatchdogStateMachine;)I

    move-result v16

    move/from16 v0, v16

    if-ne v15, v0, :cond_0

    .line 802
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mWsmChannel:Lcom/android/internal/util/AsyncChannel;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$3500(Landroid/net/wifi/WifiWatchdogStateMachine;)Lcom/android/internal/util/AsyncChannel;

    move-result-object v15

    const v16, 0x25014

    invoke-virtual/range {v15 .. v16}, Lcom/android/internal/util/AsyncChannel;->sendMessage(I)V

    .line 803
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v16, v0

    const v17, 0x2100b

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v18, v0

    invoke-static/range {v18 .. v18}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$3304(Landroid/net/wifi/WifiWatchdogStateMachine;)I

    move-result v18

    const/16 v19, 0x0

    invoke-virtual/range {v16 .. v19}, Landroid/net/wifi/WifiWatchdogStateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object v16

    const-wide/16 v17, 0x3e8

    invoke-virtual/range {v15 .. v18}, Landroid/net/wifi/WifiWatchdogStateMachine;->sendMessageDelayed(Landroid/os/Message;J)V

    goto/16 :goto_1

    .line 809
    :sswitch_3
    move-object/from16 v0, p1

    iget-object v6, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v6, Landroid/net/wifi/RssiPacketCountInfo;

    .line 810
    .local v6, info:Landroid/net/wifi/RssiPacketCountInfo;
    iget v12, v6, Landroid/net/wifi/RssiPacketCountInfo;->rssi:I

    .line 811
    .local v12, rssi:I
    move-object/from16 v0, p0

    iget v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mLastRssi:I

    add-int/2addr v15, v12

    div-int/lit8 v9, v15, 0x2

    .line 812
    .local v9, mrssi:I
    iget v13, v6, Landroid/net/wifi/RssiPacketCountInfo;->txbad:I

    .line 813
    .local v13, txbad:I
    iget v14, v6, Landroid/net/wifi/RssiPacketCountInfo;->txgood:I

    .line 814
    .local v14, txgood:I
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    new-instance v16, Ljava/lang/StringBuilder;

    invoke-direct/range {v16 .. v16}, Ljava/lang/StringBuilder;-><init>()V

    const-string v17, "Fetch RSSI succeed, rssi="

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, v16

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, " mrssi="

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, v16

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, " txbad="

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, v16

    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, " txgood="

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, v16

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v16

    invoke-virtual/range {v16 .. v16}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v16

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->logd(Ljava/lang/String;)V
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5700(Landroid/net/wifi/WifiWatchdogStateMachine;Ljava/lang/String;)V

    .line 818
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v10

    .line 819
    .local v10, now:J
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentBssid:Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$2200(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;

    move-result-object v15

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;->mLastTimeSample:J
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;->access$5800(Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;)J

    move-result-wide v15

    sub-long v15, v10, v15

    const-wide/16 v17, 0x7d0

    cmp-long v15, v15, v17

    if-gez v15, :cond_3

    .line 822
    move-object/from16 v0, p0

    iget v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mLastTxBad:I

    sub-int v2, v13, v15

    .line 823
    .local v2, dbad:I
    move-object/from16 v0, p0

    iget v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mLastTxGood:I

    sub-int v4, v14, v15

    .line 824
    .local v4, dgood:I
    add-int v5, v2, v4

    .line 826
    .local v5, dtotal:I
    if-lez v5, :cond_3

    .line 828
    int-to-double v15, v2

    int-to-double v0, v5

    move-wide/from16 v17, v0

    div-double v7, v15, v17

    .line 830
    .local v7, loss:D
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentLoss:Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5300(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;

    move-result-object v15

    invoke-virtual {v15, v7, v8, v5}, Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->update(DI)V

    .line 833
    new-instance v3, Ljava/text/DecimalFormat;

    const-string v15, "#.##"

    invoke-direct {v3, v15}, Ljava/text/DecimalFormat;-><init>(Ljava/lang/String;)V

    .line 834
    .local v3, df:Ljava/text/DecimalFormat;
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    new-instance v16, Ljava/lang/StringBuilder;

    invoke-direct/range {v16 .. v16}, Ljava/lang/StringBuilder;-><init>()V

    const-string v17, "Incremental loss="

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, v16

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, "/"

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, v16

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, " Current loss="

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v17, v0

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentLoss:Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;
    invoke-static/range {v17 .. v17}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5300(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;

    move-result-object v17

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->mValue:D
    invoke-static/range {v17 .. v17}, Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->access$5900(Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;)D

    move-result-wide v17

    const-wide/high16 v19, 0x4059

    mul-double v17, v17, v19

    move-wide/from16 v0, v17

    invoke-virtual {v3, v0, v1}, Ljava/text/DecimalFormat;->format(D)Ljava/lang/String;

    move-result-object v17

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, "% volume="

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    move-object/from16 v0, p0

    iget-object v0, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    move-object/from16 v17, v0

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentLoss:Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;
    invoke-static/range {v17 .. v17}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5300(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;

    move-result-object v17

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->mVolume:D
    invoke-static/range {v17 .. v17}, Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->access$6000(Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;)D

    move-result-wide v17

    move-wide/from16 v0, v17

    invoke-virtual {v3, v0, v1}, Ljava/text/DecimalFormat;->format(D)Ljava/lang/String;

    move-result-object v17

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    invoke-virtual/range {v16 .. v16}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v16

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->logd(Ljava/lang/String;)V
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$6100(Landroid/net/wifi/WifiWatchdogStateMachine;Ljava/lang/String;)V

    .line 839
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentBssid:Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$2200(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;

    move-result-object v15

    invoke-virtual {v15, v9, v7, v8, v5}, Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;->updateLoss(IDI)V

    .line 842
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentLoss:Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5300(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;

    move-result-object v15

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->mValue:D
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->access$5900(Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;)D

    move-result-wide v15

    const-wide/high16 v17, 0x3fe0

    cmpl-double v15, v15, v17

    if-lez v15, :cond_4

    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentLoss:Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$5300(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;

    move-result-object v15

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->mVolume:D
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;->access$6000(Landroid/net/wifi/WifiWatchdogStateMachine$VolumeWeightedEMA;)D

    move-result-wide v15

    const-wide/high16 v17, 0x4000

    cmpl-double v15, v15, v17

    if-lez v15, :cond_4

    .line 844
    move-object/from16 v0, p0

    iget v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mSampleCount:I

    add-int/lit8 v15, v15, 0x1

    move-object/from16 v0, p0

    iput v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mSampleCount:I

    const/16 v16, 0x3

    move/from16 v0, v16

    if-lt v15, v0, :cond_3

    .line 845
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentBssid:Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$2200(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;

    move-result-object v15

    invoke-virtual {v15, v12}, Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;->poorLinkDetected(I)Z

    move-result v15

    if-eqz v15, :cond_3

    .line 846
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    const/16 v16, 0x0

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->sendLinkStatusNotification(Z)V
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$1300(Landroid/net/wifi/WifiWatchdogStateMachine;Z)V

    .line 847
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$3304(Landroid/net/wifi/WifiWatchdogStateMachine;)I

    .line 855
    .end local v2           #dbad:I
    .end local v3           #df:Ljava/text/DecimalFormat;
    .end local v4           #dgood:I
    .end local v5           #dtotal:I
    .end local v7           #loss:D
    :cond_3
    :goto_2
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    #getter for: Landroid/net/wifi/WifiWatchdogStateMachine;->mCurrentBssid:Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;
    invoke-static {v15}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$2200(Landroid/net/wifi/WifiWatchdogStateMachine;)Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;

    move-result-object v15

    #setter for: Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;->mLastTimeSample:J
    invoke-static {v15, v10, v11}, Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;->access$5802(Landroid/net/wifi/WifiWatchdogStateMachine$BssidStatistics;J)J

    .line 856
    move-object/from16 v0, p0

    iput v13, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mLastTxBad:I

    .line 857
    move-object/from16 v0, p0

    iput v14, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mLastTxGood:I

    .line 858
    move-object/from16 v0, p0

    iput v12, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mLastRssi:I

    goto/16 :goto_1

    .line 850
    .restart local v2       #dbad:I
    .restart local v3       #df:Ljava/text/DecimalFormat;
    .restart local v4       #dgood:I
    .restart local v5       #dtotal:I
    .restart local v7       #loss:D
    :cond_4
    const/4 v15, 0x0

    move-object/from16 v0, p0

    iput v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->mSampleCount:I

    goto :goto_2

    .line 863
    .end local v2           #dbad:I
    .end local v3           #df:Ljava/text/DecimalFormat;
    .end local v4           #dgood:I
    .end local v5           #dtotal:I
    .end local v6           #info:Landroid/net/wifi/RssiPacketCountInfo;
    .end local v7           #loss:D
    .end local v9           #mrssi:I
    .end local v10           #now:J
    .end local v12           #rssi:I
    .end local v13           #txbad:I
    .end local v14           #txgood:I
    :sswitch_4
    move-object/from16 v0, p0

    iget-object v15, v0, Landroid/net/wifi/WifiWatchdogStateMachine$LinkMonitoringState;->this$0:Landroid/net/wifi/WifiWatchdogStateMachine;

    const-string v16, "RSSI_FETCH_FAILED"

    #calls: Landroid/net/wifi/WifiWatchdogStateMachine;->logd(Ljava/lang/String;)V
    invoke-static/range {v15 .. v16}, Landroid/net/wifi/WifiWatchdogStateMachine;->access$6200(Landroid/net/wifi/WifiWatchdogStateMachine;Ljava/lang/String;)V

    goto/16 :goto_1

    .line 783
    :sswitch_data_0
    .sparse-switch
        0x21003 -> :sswitch_0
        0x21007 -> :sswitch_1
        0x2100b -> :sswitch_2
        0x25015 -> :sswitch_3
        0x25016 -> :sswitch_4
    .end sparse-switch
.end method

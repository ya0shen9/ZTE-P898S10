.class Landroid/widget/NumberPickerZTE$InputTextFilter;
.super Landroid/text/method/NumberKeyListener;
.source "NumberPickerZTE.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/widget/NumberPickerZTE;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "InputTextFilter"
.end annotation


# instance fields
.field final synthetic this$0:Landroid/widget/NumberPickerZTE;


# direct methods
.method constructor <init>(Landroid/widget/NumberPickerZTE;)V
    .locals 0

    .prologue
    .line 2029
    iput-object p1, p0, Landroid/widget/NumberPickerZTE$InputTextFilter;->this$0:Landroid/widget/NumberPickerZTE;

    invoke-direct {p0}, Landroid/text/method/NumberKeyListener;-><init>()V

    return-void
.end method


# virtual methods
.method public filter(Ljava/lang/CharSequence;IILandroid/text/Spanned;II)Ljava/lang/CharSequence;
    .locals 13
    .param p1, "source"    # Ljava/lang/CharSequence;
    .param p2, "start"    # I
    .param p3, "end"    # I
    .param p4, "dest"    # Landroid/text/Spanned;
    .param p5, "dstart"    # I
    .param p6, "dend"    # I

    .prologue
    .line 2045
    iget-object v10, p0, Landroid/widget/NumberPickerZTE$InputTextFilter;->this$0:Landroid/widget/NumberPickerZTE;

    # getter for: Landroid/widget/NumberPickerZTE;->mDisplayedValues:[Ljava/lang/String;
    invoke-static {v10}, Landroid/widget/NumberPickerZTE;->access$900(Landroid/widget/NumberPickerZTE;)[Ljava/lang/String;

    move-result-object v10

    if-nez v10, :cond_4

    .line 2046
    invoke-super/range {p0 .. p6}, Landroid/text/method/NumberKeyListener;->filter(Ljava/lang/CharSequence;IILandroid/text/Spanned;II)Ljava/lang/CharSequence;

    move-result-object v3

    .line 2047
    .local v3, "filtered":Ljava/lang/CharSequence;
    if-nez v3, :cond_0

    .line 2048
    invoke-interface/range {p1 .. p3}, Ljava/lang/CharSequence;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v3

    .line 2051
    :cond_0
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v11, 0x0

    move-object/from16 v0, p4

    move/from16 v1, p5

    invoke-interface {v0, v11, v1}, Landroid/text/Spanned;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-interface/range {p4 .. p4}, Landroid/text/Spanned;->length()I

    move-result v11

    move-object/from16 v0, p4

    move/from16 v1, p6

    invoke-interface {v0, v1, v11}, Landroid/text/Spanned;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 2054
    .local v6, "result":Ljava/lang/String;
    const-string v10, ""

    invoke-virtual {v10, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_1

    .line 2086
    .end local v6    # "result":Ljava/lang/String;
    :goto_0
    return-object v6

    .line 2057
    .restart local v6    # "result":Ljava/lang/String;
    :cond_1
    iget-object v10, p0, Landroid/widget/NumberPickerZTE$InputTextFilter;->this$0:Landroid/widget/NumberPickerZTE;

    # invokes: Landroid/widget/NumberPickerZTE;->getSelectedPos(Ljava/lang/String;)I
    invoke-static {v10, v6}, Landroid/widget/NumberPickerZTE;->access$1000(Landroid/widget/NumberPickerZTE;Ljava/lang/String;)I

    move-result v8

    .line 2066
    .local v8, "val":I
    iget-object v10, p0, Landroid/widget/NumberPickerZTE$InputTextFilter;->this$0:Landroid/widget/NumberPickerZTE;

    # getter for: Landroid/widget/NumberPickerZTE;->mMaxValue:I
    invoke-static {v10}, Landroid/widget/NumberPickerZTE;->access$1100(Landroid/widget/NumberPickerZTE;)I

    move-result v10

    if-gt v8, v10, :cond_2

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v10

    iget-object v11, p0, Landroid/widget/NumberPickerZTE$InputTextFilter;->this$0:Landroid/widget/NumberPickerZTE;

    # getter for: Landroid/widget/NumberPickerZTE;->mMaxValue:I
    invoke-static {v11}, Landroid/widget/NumberPickerZTE;->access$1100(Landroid/widget/NumberPickerZTE;)I

    move-result v11

    invoke-static {v11}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/String;->length()I

    move-result v11

    if-le v10, v11, :cond_3

    .line 2067
    :cond_2
    const-string v6, ""

    goto :goto_0

    :cond_3
    move-object v6, v3

    .line 2069
    goto :goto_0

    .line 2072
    .end local v3    # "filtered":Ljava/lang/CharSequence;
    .end local v6    # "result":Ljava/lang/String;
    .end local v8    # "val":I
    :cond_4
    invoke-interface/range {p1 .. p3}, Ljava/lang/CharSequence;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v10

    invoke-static {v10}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    .line 2073
    .restart local v3    # "filtered":Ljava/lang/CharSequence;
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v10

    if-eqz v10, :cond_5

    .line 2074
    const-string v6, ""

    goto :goto_0

    .line 2076
    :cond_5
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v11, 0x0

    move-object/from16 v0, p4

    move/from16 v1, p5

    invoke-interface {v0, v11, v1}, Landroid/text/Spanned;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-interface/range {p4 .. p4}, Landroid/text/Spanned;->length()I

    move-result v11

    move-object/from16 v0, p4

    move/from16 v1, p6

    invoke-interface {v0, v1, v11}, Landroid/text/Spanned;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 2078
    .restart local v6    # "result":Ljava/lang/String;
    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v7

    .line 2079
    .local v7, "str":Ljava/lang/String;
    iget-object v10, p0, Landroid/widget/NumberPickerZTE$InputTextFilter;->this$0:Landroid/widget/NumberPickerZTE;

    # getter for: Landroid/widget/NumberPickerZTE;->mDisplayedValues:[Ljava/lang/String;
    invoke-static {v10}, Landroid/widget/NumberPickerZTE;->access$900(Landroid/widget/NumberPickerZTE;)[Ljava/lang/String;

    move-result-object v2

    .local v2, "arr$":[Ljava/lang/String;
    array-length v5, v2

    .local v5, "len$":I
    const/4 v4, 0x0

    .local v4, "i$":I
    :goto_1
    if-ge v4, v5, :cond_7

    aget-object v8, v2, v4

    .line 2080
    .local v8, "val":Ljava/lang/String;
    invoke-virtual {v8}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v9

    .line 2081
    .local v9, "valLowerCase":Ljava/lang/String;
    invoke-virtual {v9, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_6

    .line 2082
    iget-object v10, p0, Landroid/widget/NumberPickerZTE$InputTextFilter;->this$0:Landroid/widget/NumberPickerZTE;

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v11

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v12

    # invokes: Landroid/widget/NumberPickerZTE;->postSetSelectionCommand(II)V
    invoke-static {v10, v11, v12}, Landroid/widget/NumberPickerZTE;->access$1200(Landroid/widget/NumberPickerZTE;II)V

    .line 2083
    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v10

    move/from16 v0, p5

    invoke-virtual {v8, v0, v10}, Ljava/lang/String;->subSequence(II)Ljava/lang/CharSequence;

    move-result-object v6

    goto/16 :goto_0

    .line 2079
    :cond_6
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 2086
    .end local v8    # "val":Ljava/lang/String;
    .end local v9    # "valLowerCase":Ljava/lang/String;
    :cond_7
    const-string v6, ""

    goto/16 :goto_0
.end method

.method protected getAcceptedChars()[C
    .locals 1

    .prologue
    .line 2039
    # getter for: Landroid/widget/NumberPickerZTE;->DIGIT_CHARACTERS:[C
    invoke-static {}, Landroid/widget/NumberPickerZTE;->access$800()[C

    move-result-object v0

    return-object v0
.end method

.method public getInputType()I
    .locals 1

    .prologue
    .line 2034
    const/4 v0, 0x1

    return v0
.end method

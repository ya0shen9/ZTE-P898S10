.class Lcom/android/server/AlarmManagerService$ResultReceiver;
.super Ljava/lang/Object;
.source "AlarmManagerService.java"

# interfaces
.implements Landroid/app/PendingIntent$OnFinished;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/server/AlarmManagerService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "ResultReceiver"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/server/AlarmManagerService;


# direct methods
.method constructor <init>(Lcom/android/server/AlarmManagerService;)V
    .locals 0
    .parameter

    .prologue
    .line 1706
    iput-object p1, p0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onSendFinished(Landroid/app/PendingIntent;Landroid/content/Intent;ILjava/lang/String;Landroid/os/Bundle;)V
    .locals 16
    .parameter "pi"
    .parameter "intent"
    .parameter "resultCode"
    .parameter "resultData"
    .parameter "resultExtras"

    .prologue
    .line 1709
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mLock:Ljava/lang/Object;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$700(Lcom/android/server/AlarmManagerService;)Ljava/lang/Object;

    move-result-object v11

    monitor-enter v11

    .line 1710
    const/4 v9, 0x0

    .line 1711
    .local v9, uid:I
    const/4 v6, 0x0

    .line 1712
    .local v6, inflight:Lcom/android/server/AlarmManagerService$InFlight;
    const/4 v4, 0x0

    .local v4, i:I
    :goto_0
    :try_start_0
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10}, Ljava/util/ArrayList;->size()I

    move-result v10

    if-ge v4, v10, :cond_0

    .line 1713
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Lcom/android/server/AlarmManagerService$InFlight;

    iget-object v10, v10, Lcom/android/server/AlarmManagerService$InFlight;->mPendingIntent:Landroid/app/PendingIntent;

    move-object/from16 v0, p1

    if-ne v10, v0, :cond_5

    .line 1714
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Lcom/android/server/AlarmManagerService$InFlight;

    iget v9, v10, Lcom/android/server/AlarmManagerService$InFlight;->mUid:I

    .line 1715
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10, v4}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    move-result-object v10

    move-object v0, v10

    check-cast v0, Lcom/android/server/AlarmManagerService$InFlight;

    move-object v6, v0

    .line 1719
    :cond_0
    if-eqz v6, :cond_6

    .line 1720
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v7

    .line 1721
    .local v7, nowELAPSED:J
    iget-object v1, v6, Lcom/android/server/AlarmManagerService$InFlight;->mBroadcastStats:Lcom/android/server/AlarmManagerService$BroadcastStats;

    .line 1722
    .local v1, bs:Lcom/android/server/AlarmManagerService$BroadcastStats;
    iget v10, v1, Lcom/android/server/AlarmManagerService$BroadcastStats;->nesting:I

    add-int/lit8 v10, v10, -0x1

    iput v10, v1, Lcom/android/server/AlarmManagerService$BroadcastStats;->nesting:I

    .line 1723
    iget v10, v1, Lcom/android/server/AlarmManagerService$BroadcastStats;->nesting:I

    if-gtz v10, :cond_1

    .line 1724
    const/4 v10, 0x0

    iput v10, v1, Lcom/android/server/AlarmManagerService$BroadcastStats;->nesting:I

    .line 1725
    iget-wide v12, v1, Lcom/android/server/AlarmManagerService$BroadcastStats;->aggregateTime:J

    iget-wide v14, v1, Lcom/android/server/AlarmManagerService$BroadcastStats;->startTime:J

    sub-long v14, v7, v14

    add-long/2addr v12, v14

    iput-wide v12, v1, Lcom/android/server/AlarmManagerService$BroadcastStats;->aggregateTime:J

    .line 1727
    :cond_1
    iget-object v3, v6, Lcom/android/server/AlarmManagerService$InFlight;->mFilterStats:Lcom/android/server/AlarmManagerService$FilterStats;

    .line 1728
    .local v3, fs:Lcom/android/server/AlarmManagerService$FilterStats;
    iget v10, v3, Lcom/android/server/AlarmManagerService$FilterStats;->nesting:I

    add-int/lit8 v10, v10, -0x1

    iput v10, v3, Lcom/android/server/AlarmManagerService$FilterStats;->nesting:I

    .line 1729
    iget v10, v3, Lcom/android/server/AlarmManagerService$FilterStats;->nesting:I

    if-gtz v10, :cond_2

    .line 1730
    const/4 v10, 0x0

    iput v10, v3, Lcom/android/server/AlarmManagerService$FilterStats;->nesting:I

    .line 1731
    iget-wide v12, v3, Lcom/android/server/AlarmManagerService$FilterStats;->aggregateTime:J

    iget-wide v14, v3, Lcom/android/server/AlarmManagerService$FilterStats;->startTime:J

    sub-long v14, v7, v14

    add-long/2addr v12, v14

    iput-wide v12, v3, Lcom/android/server/AlarmManagerService$FilterStats;->aggregateTime:J

    .line 1736
    .end local v1           #bs:Lcom/android/server/AlarmManagerService$BroadcastStats;
    .end local v3           #fs:Lcom/android/server/AlarmManagerService$FilterStats;
    .end local v7           #nowELAPSED:J
    :cond_2
    :goto_1
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mTriggeredUids:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$2000(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    new-instance v12, Ljava/lang/Integer;

    invoke-direct {v12, v9}, Ljava/lang/Integer;-><init>(I)V

    invoke-virtual {v10, v12}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    .line 1737
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mBlockedUids:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$2500(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    new-instance v12, Ljava/lang/Integer;

    invoke-direct {v12, v9}, Ljava/lang/Integer;-><init>(I)V

    invoke-virtual {v10, v12}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_7

    .line 1738
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mBlockedUids:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$2500(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    new-instance v12, Ljava/lang/Integer;

    invoke-direct {v12, v9}, Ljava/lang/Integer;-><init>(I)V

    invoke-virtual {v10, v12}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    .line 1759
    :cond_3
    :goto_2
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mBroadcastRefCount:I
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1700(Lcom/android/server/AlarmManagerService;)I

    move-result v10

    if-eqz v10, :cond_4

    .line 1761
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10}, Ljava/util/ArrayList;->size()I

    move-result v10

    if-lez v10, :cond_9

    .line 1762
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    const/4 v12, 0x0

    invoke-virtual {v10, v12}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/android/server/AlarmManagerService$InFlight;

    .line 1763
    .local v5, inFlight:Lcom/android/server/AlarmManagerService$InFlight;
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    iget-object v12, v5, Lcom/android/server/AlarmManagerService$InFlight;->mPendingIntent:Landroid/app/PendingIntent;

    iget-object v13, v5, Lcom/android/server/AlarmManagerService$InFlight;->mWorkSource:Landroid/os/WorkSource;

    invoke-virtual {v10, v12, v13}, Lcom/android/server/AlarmManagerService;->setWakelockWorkSource(Landroid/app/PendingIntent;Landroid/os/WorkSource;)V

    .line 1774
    .end local v5           #inFlight:Lcom/android/server/AlarmManagerService$InFlight;
    :cond_4
    :goto_3
    monitor-exit v11

    .line 1775
    return-void

    .line 1712
    :cond_5
    add-int/lit8 v4, v4, 0x1

    goto/16 :goto_0

    .line 1734
    :cond_6
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mLog:Lcom/android/internal/util/LocalLog;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$2400(Lcom/android/server/AlarmManagerService;)Lcom/android/internal/util/LocalLog;

    move-result-object v10

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "No in-flight alarm for "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    move-object/from16 v0, p1

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v12

    const-string v13, " "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    move-object/from16 v0, p2

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v10, v12}, Lcom/android/internal/util/LocalLog;->w(Ljava/lang/String;)V

    goto/16 :goto_1

    .line 1774
    :catchall_0
    move-exception v10

    monitor-exit v11
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v10

    .line 1740
    :cond_7
    :try_start_1
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mBroadcastRefCount:I
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1700(Lcom/android/server/AlarmManagerService;)I

    move-result v10

    if-lez v10, :cond_3

    .line 1741
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1710(Lcom/android/server/AlarmManagerService;)I

    .line 1742
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mBroadcastRefCount:I
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1700(Lcom/android/server/AlarmManagerService;)I

    move-result v10

    if-nez v10, :cond_3

    .line 1743
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mWakeLock:Landroid/os/PowerManager$WakeLock;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1800(Lcom/android/server/AlarmManagerService;)Landroid/os/PowerManager$WakeLock;

    move-result-object v10

    invoke-virtual {v10}, Landroid/os/PowerManager$WakeLock;->release()V

    .line 1744
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10}, Ljava/util/ArrayList;->size()I

    move-result v10

    if-lez v10, :cond_3

    .line 1745
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mLog:Lcom/android/internal/util/LocalLog;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$2400(Lcom/android/server/AlarmManagerService;)Lcom/android/internal/util/LocalLog;

    move-result-object v10

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "Finished all broadcasts with "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    move-object/from16 v0, p0

    iget-object v13, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v13}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v13

    invoke-virtual {v13}, Ljava/util/ArrayList;->size()I

    move-result v13

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v12

    const-string v13, " remaining inflights"

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v10, v12}, Lcom/android/internal/util/LocalLog;->w(Ljava/lang/String;)V

    .line 1747
    const/4 v4, 0x0

    :goto_4
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10}, Ljava/util/ArrayList;->size()I

    move-result v10

    if-ge v4, v10, :cond_8

    .line 1748
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mLog:Lcom/android/internal/util/LocalLog;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$2400(Lcom/android/server/AlarmManagerService;)Lcom/android/internal/util/LocalLog;

    move-result-object v10

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "  Remaining #"

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v12

    const-string v13, ": "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    move-object/from16 v0, p0

    iget-object v13, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v13}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v13

    invoke-virtual {v13, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v13

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v10, v12}, Lcom/android/internal/util/LocalLog;->w(Ljava/lang/String;)V

    .line 1747
    add-int/lit8 v4, v4, 0x1

    goto :goto_4

    .line 1750
    :cond_8
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mInFlight:Ljava/util/ArrayList;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1900(Lcom/android/server/AlarmManagerService;)Ljava/util/ArrayList;

    move-result-object v10

    invoke-virtual {v10}, Ljava/util/ArrayList;->clear()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto/16 :goto_2

    .line 1767
    :cond_9
    :try_start_2
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mLog:Lcom/android/internal/util/LocalLog;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$2400(Lcom/android/server/AlarmManagerService;)Lcom/android/internal/util/LocalLog;

    move-result-object v10

    const-string v12, "Alarm wakelock still held but sent queue empty"

    invoke-virtual {v10, v12}, Lcom/android/internal/util/LocalLog;->w(Ljava/lang/String;)V

    .line 1768
    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/AlarmManagerService$ResultReceiver;->this$0:Lcom/android/server/AlarmManagerService;

    #getter for: Lcom/android/server/AlarmManagerService;->mWakeLock:Landroid/os/PowerManager$WakeLock;
    invoke-static {v10}, Lcom/android/server/AlarmManagerService;->access$1800(Lcom/android/server/AlarmManagerService;)Landroid/os/PowerManager$WakeLock;

    move-result-object v10

    const/4 v12, 0x0

    invoke-virtual {v10, v12}, Landroid/os/PowerManager$WakeLock;->setWorkSource(Landroid/os/WorkSource;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_2 .. :try_end_2} :catch_0

    goto/16 :goto_3

    .line 1769
    :catch_0
    move-exception v2

    .line 1770
    .local v2, ex:Ljava/lang/IllegalArgumentException;
    :try_start_3
    invoke-virtual {v2}, Ljava/lang/IllegalArgumentException;->printStackTrace()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto/16 :goto_3
.end method

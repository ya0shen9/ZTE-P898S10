.class Lcom/android/server/NotificationManagerService$6;
.super Ljava/lang/Object;
.source "NotificationManagerService.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/server/NotificationManagerService;->enqueueNotificationInternal(Ljava/lang/String;Ljava/lang/String;IILjava/lang/String;ILandroid/app/Notification;[II)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/server/NotificationManagerService;

.field final synthetic val$callingPid:I

.field final synthetic val$callingUid:I

.field final synthetic val$id:I

.field final synthetic val$isSystemNotification:Z

.field final synthetic val$notification:Landroid/app/Notification;

.field final synthetic val$pkg:Ljava/lang/String;

.field final synthetic val$tag:Ljava/lang/String;

.field final synthetic val$user:Landroid/os/UserHandle;

.field final synthetic val$userId:I


# direct methods
.method constructor <init>(Lcom/android/server/NotificationManagerService;Landroid/app/Notification;Ljava/lang/String;IZILjava/lang/String;ILandroid/os/UserHandle;I)V
    .locals 0
    .parameter
    .parameter
    .parameter
    .parameter
    .parameter
    .parameter
    .parameter
    .parameter
    .parameter
    .parameter

    .prologue
    .line 1769
    iput-object p1, p0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    iput-object p2, p0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iput-object p3, p0, Lcom/android/server/NotificationManagerService$6;->val$pkg:Ljava/lang/String;

    iput p4, p0, Lcom/android/server/NotificationManagerService$6;->val$callingUid:I

    iput-boolean p5, p0, Lcom/android/server/NotificationManagerService$6;->val$isSystemNotification:Z

    iput p6, p0, Lcom/android/server/NotificationManagerService$6;->val$id:I

    iput-object p7, p0, Lcom/android/server/NotificationManagerService$6;->val$tag:Ljava/lang/String;

    iput p8, p0, Lcom/android/server/NotificationManagerService$6;->val$callingPid:I

    iput-object p9, p0, Lcom/android/server/NotificationManagerService$6;->val$user:Landroid/os/UserHandle;

    iput p10, p0, Lcom/android/server/NotificationManagerService$6;->val$userId:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 38

    .prologue
    .line 1776
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    move-object/from16 v0, p0

    iget-object v5, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v5, v5, Landroid/app/Notification;->priority:I

    const/4 v6, -0x2

    const/4 v7, 0x2

    #calls: Lcom/android/server/NotificationManagerService;->clamp(III)I
    invoke-static {v5, v6, v7}, Lcom/android/server/NotificationManagerService;->access$2600(III)I

    move-result v5

    iput v5, v4, Landroid/app/Notification;->priority:I

    .line 1779
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit16 v4, v4, 0x80

    if-eqz v4, :cond_0

    .line 1780
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->priority:I

    const/4 v5, 0x2

    if-ge v4, v5, :cond_0

    .line 1781
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    const/4 v5, 0x2

    iput v5, v4, Landroid/app/Notification;->priority:I

    .line 1790
    :cond_0
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$pkg:Ljava/lang/String;

    const-string v5, "com.zte.heartyservice"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 1791
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    const/4 v5, 0x4

    iput v5, v4, Landroid/app/Notification;->priority:I

    .line 1796
    :cond_1
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->priority:I

    mul-int/lit8 v9, v4, 0xa

    .line 1802
    .local v9, score:I
    move/from16 v23, v9

    .line 1803
    .local v23, initialScore:I
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mScorers:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$2700(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v4

    invoke-virtual {v4}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_3

    .line 1804
    const-string v4, "NotificationService"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Initial score is "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "."

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Slog;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1805
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mScorers:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$2700(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v4

    invoke-virtual {v4}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v19

    .local v19, i$:Ljava/util/Iterator;
    :goto_0
    invoke-interface/range {v19 .. v19}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_2

    invoke-interface/range {v19 .. v19}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v29

    check-cast v29, Lcom/android/internal/notification/NotificationScorer;

    .line 1807
    .local v29, scorer:Lcom/android/internal/notification/NotificationScorer;
    :try_start_0
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    move-object/from16 v0, v29

    invoke-interface {v0, v4, v9}, Lcom/android/internal/notification/NotificationScorer;->getScore(Landroid/app/Notification;I)I
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    move-result v9

    goto :goto_0

    .line 1808
    :catch_0
    move-exception v32

    .line 1809
    .local v32, t:Ljava/lang/Throwable;
    const-string v4, "NotificationService"

    const-string v5, "Scorer threw on .getScore."

    move-object/from16 v0, v32

    invoke-static {v4, v5, v0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0

    .line 1812
    .end local v29           #scorer:Lcom/android/internal/notification/NotificationScorer;
    .end local v32           #t:Ljava/lang/Throwable;
    :cond_2
    const-string v4, "NotificationService"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Final score is "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "."

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Slog;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1816
    .end local v19           #i$:Ljava/util/Iterator;
    :cond_3
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget-object v5, v4, Landroid/app/Notification;->extras:Landroid/os/Bundle;

    const-string v6, "android.scoreModified"

    move/from16 v0, v23

    if-eq v9, v0, :cond_5

    const/4 v4, 0x1

    :goto_1
    invoke-virtual {v5, v6, v4}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 1820
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    move-object/from16 v0, p0

    iget-object v5, v0, Lcom/android/server/NotificationManagerService$6;->val$pkg:Ljava/lang/String;

    move-object/from16 v0, p0

    iget v6, v0, Lcom/android/server/NotificationManagerService$6;->val$callingUid:I

    #calls: Lcom/android/server/NotificationManagerService;->noteNotificationOp(Ljava/lang/String;I)Z
    invoke-static {v4, v5, v6}, Lcom/android/server/NotificationManagerService;->access$2800(Lcom/android/server/NotificationManagerService;Ljava/lang/String;I)Z

    move-result v4

    if-nez v4, :cond_4

    .line 1821
    move-object/from16 v0, p0

    iget-boolean v4, v0, Lcom/android/server/NotificationManagerService$6;->val$isSystemNotification:Z

    if-nez v4, :cond_4

    .line 1822
    const/16 v9, -0x3e8

    .line 1823
    const-string v4, "NotificationService"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Suppressing notification from package "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    move-object/from16 v0, p0

    iget-object v6, v0, Lcom/android/server/NotificationManagerService$6;->val$pkg:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, " by user request."

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1829
    :cond_4
    const-string v4, "NotificationService"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Assigned score="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, " to "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    move-object/from16 v0, p0

    iget-object v6, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Slog;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1832
    const/16 v4, -0x14

    if-ge v9, v4, :cond_6

    .line 2055
    :goto_2
    return-void

    .line 1816
    :cond_5
    const/4 v4, 0x0

    goto :goto_1

    .line 1838
    :cond_6
    const/16 v4, -0xa

    if-lt v9, v4, :cond_16

    const/4 v14, 0x1

    .line 1840
    .local v14, canInterrupt:Z
    :goto_3
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mNotificationList:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$100(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v37

    monitor-enter v37

    .line 1841
    :try_start_1
    new-instance v3, Landroid/service/notification/StatusBarNotification;

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$pkg:Ljava/lang/String;

    move-object/from16 v0, p0

    iget v5, v0, Lcom/android/server/NotificationManagerService$6;->val$id:I

    move-object/from16 v0, p0

    iget-object v6, v0, Lcom/android/server/NotificationManagerService$6;->val$tag:Ljava/lang/String;

    move-object/from16 v0, p0

    iget v7, v0, Lcom/android/server/NotificationManagerService$6;->val$callingUid:I

    move-object/from16 v0, p0

    iget v8, v0, Lcom/android/server/NotificationManagerService$6;->val$callingPid:I

    move-object/from16 v0, p0

    iget-object v10, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    move-object/from16 v0, p0

    iget-object v11, v0, Lcom/android/server/NotificationManagerService$6;->val$user:Landroid/os/UserHandle;

    invoke-direct/range {v3 .. v11}, Landroid/service/notification/StatusBarNotification;-><init>(Ljava/lang/String;ILjava/lang/String;IIILandroid/app/Notification;Landroid/os/UserHandle;)V

    .line 1843
    .local v3, n:Landroid/service/notification/StatusBarNotification;
    new-instance v27, Lcom/android/server/NotificationManagerService$NotificationRecord;

    move-object/from16 v0, v27

    invoke-direct {v0, v3}, Lcom/android/server/NotificationManagerService$NotificationRecord;-><init>(Landroid/service/notification/StatusBarNotification;)V

    .line 1844
    .local v27, r:Lcom/android/server/NotificationManagerService$NotificationRecord;
    const/16 v25, 0x0

    .line 1846
    .local v25, old:Lcom/android/server/NotificationManagerService$NotificationRecord;
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    move-object/from16 v0, p0

    iget-object v5, v0, Lcom/android/server/NotificationManagerService$6;->val$pkg:Ljava/lang/String;

    move-object/from16 v0, p0

    iget-object v6, v0, Lcom/android/server/NotificationManagerService$6;->val$tag:Ljava/lang/String;

    move-object/from16 v0, p0

    iget v7, v0, Lcom/android/server/NotificationManagerService$6;->val$id:I

    move-object/from16 v0, p0

    iget v8, v0, Lcom/android/server/NotificationManagerService$6;->val$userId:I

    #calls: Lcom/android/server/NotificationManagerService;->indexOfNotificationLocked(Ljava/lang/String;Ljava/lang/String;II)I
    invoke-static {v4, v5, v6, v7, v8}, Lcom/android/server/NotificationManagerService;->access$2900(Lcom/android/server/NotificationManagerService;Ljava/lang/String;Ljava/lang/String;II)I

    move-result v22

    .line 1847
    .local v22, index:I
    if-gez v22, :cond_17

    .line 1848
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mNotificationList:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$100(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v4

    move-object/from16 v0, v27

    invoke-virtual {v4, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1861
    :cond_7
    :goto_4
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit8 v4, v4, 0x40

    if-eqz v4, :cond_8

    .line 1862
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v5, v4, Landroid/app/Notification;->flags:I

    or-int/lit8 v5, v5, 0x22

    iput v5, v4, Landroid/app/Notification;->flags:I

    .line 1867
    :cond_8
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move-result-wide v33

    .line 1869
    .local v33, token:J
    :try_start_2
    invoke-static {}, Landroid/app/ActivityManager;->getCurrentUser()I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    move-result v16

    .line 1871
    .local v16, currentUser:I
    :try_start_3
    invoke-static/range {v33 .. v34}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1874
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->icon:I

    if-eqz v4, :cond_1a

    .line 1875
    if-eqz v25, :cond_18

    move-object/from16 v0, v25

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->statusBarKey:Landroid/os/IBinder;

    if-eqz v4, :cond_18

    .line 1876
    move-object/from16 v0, v25

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->statusBarKey:Landroid/os/IBinder;

    move-object/from16 v0, v27

    iput-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->statusBarKey:Landroid/os/IBinder;

    .line 1877
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    move-result-wide v20

    .line 1879
    .local v20, identity:J
    :try_start_4
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mStatusBar:Lcom/android/server/StatusBarManagerService;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$3000(Lcom/android/server/NotificationManagerService;)Lcom/android/server/StatusBarManagerService;

    move-result-object v4

    move-object/from16 v0, v27

    iget-object v5, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->statusBarKey:Landroid/os/IBinder;

    invoke-virtual {v4, v5, v3}, Lcom/android/server/StatusBarManagerService;->updateNotification(Landroid/os/IBinder;Landroid/service/notification/StatusBarNotification;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    .line 1882
    :try_start_5
    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1898
    :goto_5
    move-object/from16 v0, p0

    iget v4, v0, Lcom/android/server/NotificationManagerService$6;->val$userId:I

    move/from16 v0, v16

    if-ne v0, v4, :cond_9

    .line 1899
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    move-object/from16 v0, p0

    iget-object v5, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    move-object/from16 v0, p0

    iget-object v6, v0, Lcom/android/server/NotificationManagerService$6;->val$pkg:Ljava/lang/String;

    #calls: Lcom/android/server/NotificationManagerService;->sendAccessibilityEvent(Landroid/app/Notification;Ljava/lang/CharSequence;)V
    invoke-static {v4, v5, v6}, Lcom/android/server/NotificationManagerService;->access$3200(Lcom/android/server/NotificationManagerService;Landroid/app/Notification;Ljava/lang/CharSequence;)V

    .line 1902
    :cond_9
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    move-object/from16 v0, v27

    #calls: Lcom/android/server/NotificationManagerService;->notifyPostedLocked(Lcom/android/server/NotificationManagerService$NotificationRecord;)V
    invoke-static {v4, v0}, Lcom/android/server/NotificationManagerService;->access$3300(Lcom/android/server/NotificationManagerService;Lcom/android/server/NotificationManagerService$NotificationRecord;)V

    .line 1923
    .end local v20           #identity:J
    :goto_6
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    iget-object v4, v4, Lcom/android/server/NotificationManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v4}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v5, 0x2070004

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result v30

    .line 1927
    .local v30, smsRingtone:Z
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mDisabledNotifications:I
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$500(Lcom/android/server/NotificationManagerService;)I

    move-result v4

    const/high16 v5, 0x4

    and-int/2addr v4, v5

    if-eqz v4, :cond_a

    if-eqz v30, :cond_13

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mInCall:Z
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$1600(Lcom/android/server/NotificationManagerService;)Z

    move-result v4

    if-eqz v4, :cond_13

    :cond_a
    if-eqz v25, :cond_b

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit8 v4, v4, 0x8

    if-nez v4, :cond_13

    :cond_b
    invoke-virtual/range {v27 .. v27}, Lcom/android/server/NotificationManagerService$NotificationRecord;->getUserId()I

    move-result v4

    const/4 v5, -0x1

    if-eq v4, v5, :cond_c

    invoke-virtual/range {v27 .. v27}, Lcom/android/server/NotificationManagerService$NotificationRecord;->getUserId()I

    move-result v4

    move-object/from16 v0, p0

    iget v5, v0, Lcom/android/server/NotificationManagerService$6;->val$userId:I

    if-ne v4, v5, :cond_13

    invoke-virtual/range {v27 .. v27}, Lcom/android/server/NotificationManagerService$NotificationRecord;->getUserId()I

    move-result v4

    move/from16 v0, v16

    if-ne v4, v0, :cond_13

    :cond_c
    if-eqz v14, :cond_13

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mSystemReady:Z
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$3500(Lcom/android/server/NotificationManagerService;)Z

    move-result v4

    if-eqz v4, :cond_13

    .line 1936
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    iget-object v4, v4, Lcom/android/server/NotificationManagerService;->mContext:Landroid/content/Context;

    const-string v5, "audio"

    invoke-virtual {v4, v5}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/media/AudioManager;

    .line 1944
    .local v12, audioManager:Landroid/media/AudioManager;
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->defaults:I

    and-int/lit8 v4, v4, 0x1

    if-nez v4, :cond_d

    sget-object v4, Landroid/provider/Settings$System;->DEFAULT_NOTIFICATION_URI:Landroid/net/Uri;

    move-object/from16 v0, p0

    iget-object v5, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget-object v5, v5, Landroid/app/Notification;->sound:Landroid/net/Uri;

    invoke-virtual {v4, v5}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1c

    :cond_d
    const/16 v35, 0x1

    .line 1949
    .local v35, useDefaultSound:Z
    :goto_7
    const/16 v31, 0x0

    .line 1950
    .local v31, soundUri:Landroid/net/Uri;
    const/16 v18, 0x0

    .line 1952
    .local v18, hasValidSound:Z
    if-eqz v35, :cond_1e

    .line 1953
    sget-object v31, Landroid/provider/Settings$System;->DEFAULT_NOTIFICATION_URI:Landroid/net/Uri;

    .line 1956
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    iget-object v4, v4, Lcom/android/server/NotificationManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v4}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v28

    .line 1957
    .local v28, resolver:Landroid/content/ContentResolver;
    const-string v4, "notification_sound"

    move-object/from16 v0, v28

    invoke-static {v0, v4}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_1d

    const/16 v18, 0x1

    .line 1964
    .end local v28           #resolver:Landroid/content/ContentResolver;
    :cond_e
    :goto_8
    if-eqz v18, :cond_10

    .line 1965
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit8 v4, v4, 0x4

    if-eqz v4, :cond_20

    const/16 v24, 0x1

    .line 1967
    .local v24, looping:Z
    :goto_9
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->audioStreamType:I

    if-ltz v4, :cond_21

    .line 1968
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v13, v4, Landroid/app/Notification;->audioStreamType:I

    .line 1972
    .local v13, audioStreamType:I
    :goto_a
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    move-object/from16 v0, v27

    #setter for: Lcom/android/server/NotificationManagerService;->mSoundNotification:Lcom/android/server/NotificationManagerService$NotificationRecord;
    invoke-static {v4, v0}, Lcom/android/server/NotificationManagerService;->access$902(Lcom/android/server/NotificationManagerService;Lcom/android/server/NotificationManagerService$NotificationRecord;)Lcom/android/server/NotificationManagerService$NotificationRecord;

    .line 1975
    invoke-virtual {v12, v13}, Landroid/media/AudioManager;->getStreamVolume(I)I

    move-result v4

    if-eqz v4, :cond_10

    invoke-virtual {v12}, Landroid/media/AudioManager;->isAudioFocusExclusive()Z

    move-result v4

    if-nez v4, :cond_10

    .line 1977
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    move-result-wide v20

    .line 1979
    .restart local v20       #identity:J
    :try_start_6
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mAudioService:Landroid/media/IAudioService;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$600(Lcom/android/server/NotificationManagerService;)Landroid/media/IAudioService;

    move-result-object v4

    invoke-interface {v4}, Landroid/media/IAudioService;->getRingtonePlayer()Landroid/media/IRingtonePlayer;

    move-result-object v26

    .line 1980
    .local v26, player:Landroid/media/IRingtonePlayer;
    if-eqz v26, :cond_f

    .line 1981
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$user:Landroid/os/UserHandle;

    move-object/from16 v0, v26

    move-object/from16 v1, v31

    move/from16 v2, v24

    invoke-interface {v0, v1, v4, v2, v13}, Landroid/media/IRingtonePlayer;->playAsync(Landroid/net/Uri;Landroid/os/UserHandle;ZI)V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_5
    .catch Landroid/os/RemoteException; {:try_start_6 .. :try_end_6} :catch_1

    .line 1985
    :cond_f
    :try_start_7
    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1992
    .end local v13           #audioStreamType:I
    .end local v20           #identity:J
    .end local v24           #looping:Z
    .end local v26           #player:Landroid/media/IRingtonePlayer;
    :cond_10
    :goto_b
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget-object v4, v4, Landroid/app/Notification;->vibrate:[J

    if-eqz v4, :cond_22

    const/16 v17, 0x1

    .line 1996
    .local v17, hasCustomVibrate:Z
    :goto_c
    if-nez v17, :cond_23

    if-eqz v18, :cond_23

    invoke-virtual {v12}, Landroid/media/AudioManager;->getRingerMode()I

    move-result v4

    const/4 v5, 0x1

    if-ne v4, v5, :cond_23

    const/4 v15, 0x1

    .line 2003
    .local v15, convertSoundToVibration:Z
    :goto_d
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->defaults:I

    and-int/lit8 v4, v4, 0x2

    if-eqz v4, :cond_24

    const/16 v36, 0x1

    .line 2006
    .local v36, useDefaultVibrate:Z
    :goto_e
    if-nez v36, :cond_11

    if-nez v15, :cond_11

    if-eqz v17, :cond_13

    :cond_11
    invoke-virtual {v12}, Landroid/media/AudioManager;->getRingerMode()I

    move-result v4

    if-eqz v4, :cond_13

    .line 2009
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    move-object/from16 v0, v27

    #setter for: Lcom/android/server/NotificationManagerService;->mVibrateNotification:Lcom/android/server/NotificationManagerService$NotificationRecord;
    invoke-static {v4, v0}, Lcom/android/server/NotificationManagerService;->access$1002(Lcom/android/server/NotificationManagerService;Lcom/android/server/NotificationManagerService$NotificationRecord;)Lcom/android/server/NotificationManagerService$NotificationRecord;

    .line 2011
    if-nez v36, :cond_12

    if-eqz v15, :cond_27

    .line 2014
    :cond_12
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    move-result-wide v20

    .line 2016
    .restart local v20       #identity:J
    :try_start_8
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mVibrator:Landroid/os/Vibrator;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$700(Lcom/android/server/NotificationManagerService;)Landroid/os/Vibrator;

    move-result-object v6

    move-object/from16 v0, v27

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->sbn:Landroid/service/notification/StatusBarNotification;

    invoke-virtual {v4}, Landroid/service/notification/StatusBarNotification;->getUid()I

    move-result v7

    move-object/from16 v0, v27

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->sbn:Landroid/service/notification/StatusBarNotification;

    invoke-virtual {v4}, Landroid/service/notification/StatusBarNotification;->getBasePkg()Ljava/lang/String;

    move-result-object v8

    if-eqz v36, :cond_25

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mDefaultVibrationPattern:[J
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$3600(Lcom/android/server/NotificationManagerService;)[J

    move-result-object v4

    move-object v5, v4

    :goto_f
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit8 v4, v4, 0x4

    if-eqz v4, :cond_26

    const/4 v4, 0x0

    :goto_10
    invoke-virtual {v6, v7, v8, v5, v4}, Landroid/os/Vibrator;->vibrate(ILjava/lang/String;[JI)V
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_6

    .line 2022
    :try_start_9
    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 2037
    .end local v12           #audioManager:Landroid/media/AudioManager;
    .end local v15           #convertSoundToVibration:Z
    .end local v17           #hasCustomVibrate:Z
    .end local v18           #hasValidSound:Z
    .end local v20           #identity:J
    .end local v31           #soundUri:Landroid/net/Uri;
    .end local v35           #useDefaultSound:Z
    .end local v36           #useDefaultVibrate:Z
    :cond_13
    :goto_11
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mLights:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$1100(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v4

    move-object/from16 v0, v25

    invoke-virtual {v4, v0}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    .line 2038
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mLedNotification:Lcom/android/server/NotificationManagerService$NotificationRecord;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$1200(Lcom/android/server/NotificationManagerService;)Lcom/android/server/NotificationManagerService$NotificationRecord;

    move-result-object v4

    move-object/from16 v0, v25

    if-ne v4, v0, :cond_14

    .line 2039
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    const/4 v5, 0x0

    #setter for: Lcom/android/server/NotificationManagerService;->mLedNotification:Lcom/android/server/NotificationManagerService$NotificationRecord;
    invoke-static {v4, v5}, Lcom/android/server/NotificationManagerService;->access$1202(Lcom/android/server/NotificationManagerService;Lcom/android/server/NotificationManagerService$NotificationRecord;)Lcom/android/server/NotificationManagerService$NotificationRecord;

    .line 2044
    :cond_14
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit8 v4, v4, 0x1

    if-eqz v4, :cond_29

    if-eqz v14, :cond_29

    .line 2046
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mLights:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$1100(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v4

    move-object/from16 v0, v27

    invoke-virtual {v4, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 2047
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #calls: Lcom/android/server/NotificationManagerService;->updateLightsLocked()V
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$1300(Lcom/android/server/NotificationManagerService;)V

    .line 2054
    :cond_15
    :goto_12
    monitor-exit v37

    goto/16 :goto_2

    .end local v3           #n:Landroid/service/notification/StatusBarNotification;
    .end local v16           #currentUser:I
    .end local v22           #index:I
    .end local v25           #old:Lcom/android/server/NotificationManagerService$NotificationRecord;
    .end local v27           #r:Lcom/android/server/NotificationManagerService$NotificationRecord;
    .end local v30           #smsRingtone:Z
    .end local v33           #token:J
    :catchall_0
    move-exception v4

    monitor-exit v37
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_0

    throw v4

    .line 1838
    .end local v14           #canInterrupt:Z
    :cond_16
    const/4 v14, 0x0

    goto/16 :goto_3

    .line 1850
    .restart local v3       #n:Landroid/service/notification/StatusBarNotification;
    .restart local v14       #canInterrupt:Z
    .restart local v22       #index:I
    .restart local v25       #old:Lcom/android/server/NotificationManagerService$NotificationRecord;
    .restart local v27       #r:Lcom/android/server/NotificationManagerService$NotificationRecord;
    :cond_17
    :try_start_a
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mNotificationList:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$100(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v4

    move/from16 v0, v22

    invoke-virtual {v4, v0}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    move-result-object v25

    .end local v25           #old:Lcom/android/server/NotificationManagerService$NotificationRecord;
    check-cast v25, Lcom/android/server/NotificationManagerService$NotificationRecord;

    .line 1851
    .restart local v25       #old:Lcom/android/server/NotificationManagerService$NotificationRecord;
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mNotificationList:Ljava/util/ArrayList;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$100(Lcom/android/server/NotificationManagerService;)Ljava/util/ArrayList;

    move-result-object v4

    move/from16 v0, v22

    move-object/from16 v1, v27

    invoke-virtual {v4, v0, v1}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    .line 1853
    if-eqz v25, :cond_7

    .line 1854
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v5, v4, Landroid/app/Notification;->flags:I

    invoke-virtual/range {v25 .. v25}, Lcom/android/server/NotificationManagerService$NotificationRecord;->getNotification()Landroid/app/Notification;

    move-result-object v6

    iget v6, v6, Landroid/app/Notification;->flags:I

    and-int/lit8 v6, v6, 0x40

    or-int/2addr v5, v6

    iput v5, v4, Landroid/app/Notification;->flags:I

    goto/16 :goto_4

    .line 1871
    .restart local v33       #token:J
    :catchall_1
    move-exception v4

    invoke-static/range {v33 .. v34}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    throw v4

    .line 1882
    .restart local v16       #currentUser:I
    .restart local v20       #identity:J
    :catchall_2
    move-exception v4

    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    throw v4

    .line 1885
    .end local v20           #identity:J
    :cond_18
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_0

    move-result-wide v20

    .line 1887
    .restart local v20       #identity:J
    :try_start_b
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mStatusBar:Lcom/android/server/StatusBarManagerService;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$3000(Lcom/android/server/NotificationManagerService;)Lcom/android/server/StatusBarManagerService;

    move-result-object v4

    invoke-virtual {v4, v3}, Lcom/android/server/StatusBarManagerService;->addNotification(Landroid/service/notification/StatusBarNotification;)Landroid/os/IBinder;

    move-result-object v4

    move-object/from16 v0, v27

    iput-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->statusBarKey:Landroid/os/IBinder;

    .line 1888
    invoke-virtual {v3}, Landroid/service/notification/StatusBarNotification;->getNotification()Landroid/app/Notification;

    move-result-object v4

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit8 v4, v4, 0x1

    if-eqz v4, :cond_19

    if-eqz v14, :cond_19

    .line 1890
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mAttentionLight:Lcom/android/server/LightsService$Light;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$3100(Lcom/android/server/NotificationManagerService;)Lcom/android/server/LightsService$Light;

    move-result-object v4

    invoke-virtual {v4}, Lcom/android/server/LightsService$Light;->pulse()V
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_3

    .line 1894
    :cond_19
    :try_start_c
    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    goto/16 :goto_5

    :catchall_3
    move-exception v4

    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    throw v4

    .line 1904
    .end local v20           #identity:J
    :cond_1a
    const-string v4, "NotificationService"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Not posting notification with icon==0: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    move-object/from16 v0, p0

    iget-object v6, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1905
    if-eqz v25, :cond_1b

    move-object/from16 v0, v25

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->statusBarKey:Landroid/os/IBinder;

    if-eqz v4, :cond_1b

    .line 1906
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J
    :try_end_c
    .catchall {:try_start_c .. :try_end_c} :catchall_0

    move-result-wide v20

    .line 1908
    .restart local v20       #identity:J
    :try_start_d
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mStatusBar:Lcom/android/server/StatusBarManagerService;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$3000(Lcom/android/server/NotificationManagerService;)Lcom/android/server/StatusBarManagerService;

    move-result-object v4

    move-object/from16 v0, v25

    iget-object v5, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->statusBarKey:Landroid/os/IBinder;

    invoke-virtual {v4, v5}, Lcom/android/server/StatusBarManagerService;->removeNotification(Landroid/os/IBinder;)V
    :try_end_d
    .catchall {:try_start_d .. :try_end_d} :catchall_4

    .line 1911
    :try_start_e
    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1914
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    move-object/from16 v0, v27

    #calls: Lcom/android/server/NotificationManagerService;->notifyRemovedLocked(Lcom/android/server/NotificationManagerService$NotificationRecord;)V
    invoke-static {v4, v0}, Lcom/android/server/NotificationManagerService;->access$3400(Lcom/android/server/NotificationManagerService;Lcom/android/server/NotificationManagerService$NotificationRecord;)V

    .line 1918
    .end local v20           #identity:J
    :cond_1b
    const-string v4, "NotificationService"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "WARNING: In a future release this will crash the app: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v3}, Landroid/service/notification/StatusBarNotification;->getPackageName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_6

    .line 1911
    .restart local v20       #identity:J
    :catchall_4
    move-exception v4

    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    throw v4

    .line 1944
    .end local v20           #identity:J
    .restart local v12       #audioManager:Landroid/media/AudioManager;
    .restart local v30       #smsRingtone:Z
    :cond_1c
    const/16 v35, 0x0

    goto/16 :goto_7

    .line 1957
    .restart local v18       #hasValidSound:Z
    .restart local v28       #resolver:Landroid/content/ContentResolver;
    .restart local v31       #soundUri:Landroid/net/Uri;
    .restart local v35       #useDefaultSound:Z
    :cond_1d
    const/16 v18, 0x0

    goto/16 :goto_8

    .line 1959
    .end local v28           #resolver:Landroid/content/ContentResolver;
    :cond_1e
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget-object v4, v4, Landroid/app/Notification;->sound:Landroid/net/Uri;

    if-eqz v4, :cond_e

    .line 1960
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget-object v0, v4, Landroid/app/Notification;->sound:Landroid/net/Uri;

    move-object/from16 v31, v0

    .line 1961
    if-eqz v31, :cond_1f

    const/16 v18, 0x1

    :goto_13
    goto/16 :goto_8

    :cond_1f
    const/16 v18, 0x0

    goto :goto_13

    .line 1965
    :cond_20
    const/16 v24, 0x0

    goto/16 :goto_9

    .line 1970
    .restart local v24       #looping:Z
    :cond_21
    const/4 v13, 0x5

    .restart local v13       #audioStreamType:I
    goto/16 :goto_a

    .line 1985
    .restart local v20       #identity:J
    :catchall_5
    move-exception v4

    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    throw v4
    :try_end_e
    .catchall {:try_start_e .. :try_end_e} :catchall_0

    .line 1992
    .end local v13           #audioStreamType:I
    .end local v20           #identity:J
    .end local v24           #looping:Z
    :cond_22
    const/16 v17, 0x0

    goto/16 :goto_c

    .line 1996
    .restart local v17       #hasCustomVibrate:Z
    :cond_23
    const/4 v15, 0x0

    goto/16 :goto_d

    .line 2003
    .restart local v15       #convertSoundToVibration:Z
    :cond_24
    const/16 v36, 0x0

    goto/16 :goto_e

    .line 2016
    .restart local v20       #identity:J
    .restart local v36       #useDefaultVibrate:Z
    :cond_25
    :try_start_f
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mFallbackVibrationPattern:[J
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$3700(Lcom/android/server/NotificationManagerService;)[J
    :try_end_f
    .catchall {:try_start_f .. :try_end_f} :catchall_6

    move-result-object v4

    move-object v5, v4

    goto/16 :goto_f

    :cond_26
    const/4 v4, -0x1

    goto/16 :goto_10

    .line 2022
    :catchall_6
    move-exception v4

    :try_start_10
    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    throw v4

    .line 2024
    .end local v20           #identity:J
    :cond_27
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget-object v4, v4, Landroid/app/Notification;->vibrate:[J

    array-length v4, v4

    const/4 v5, 0x1

    if-le v4, v5, :cond_13

    .line 2027
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #getter for: Lcom/android/server/NotificationManagerService;->mVibrator:Landroid/os/Vibrator;
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$700(Lcom/android/server/NotificationManagerService;)Landroid/os/Vibrator;

    move-result-object v5

    move-object/from16 v0, v27

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->sbn:Landroid/service/notification/StatusBarNotification;

    invoke-virtual {v4}, Landroid/service/notification/StatusBarNotification;->getUid()I

    move-result v6

    move-object/from16 v0, v27

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$NotificationRecord;->sbn:Landroid/service/notification/StatusBarNotification;

    invoke-virtual {v4}, Landroid/service/notification/StatusBarNotification;->getBasePkg()Ljava/lang/String;

    move-result-object v7

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget-object v8, v4, Landroid/app/Notification;->vibrate:[J

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->val$notification:Landroid/app/Notification;

    iget v4, v4, Landroid/app/Notification;->flags:I

    and-int/lit8 v4, v4, 0x4

    if-eqz v4, :cond_28

    const/4 v4, 0x0

    :goto_14
    invoke-virtual {v5, v6, v7, v8, v4}, Landroid/os/Vibrator;->vibrate(ILjava/lang/String;[JI)V

    goto/16 :goto_11

    :cond_28
    const/4 v4, -0x1

    goto :goto_14

    .line 2049
    .end local v12           #audioManager:Landroid/media/AudioManager;
    .end local v15           #convertSoundToVibration:Z
    .end local v17           #hasCustomVibrate:Z
    .end local v18           #hasValidSound:Z
    .end local v31           #soundUri:Landroid/net/Uri;
    .end local v35           #useDefaultSound:Z
    .end local v36           #useDefaultVibrate:Z
    :cond_29
    if-eqz v25, :cond_15

    invoke-virtual/range {v25 .. v25}, Lcom/android/server/NotificationManagerService$NotificationRecord;->getFlags()I

    move-result v4

    and-int/lit8 v4, v4, 0x1

    if-eqz v4, :cond_15

    .line 2051
    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/android/server/NotificationManagerService$6;->this$0:Lcom/android/server/NotificationManagerService;

    #calls: Lcom/android/server/NotificationManagerService;->updateLightsLocked()V
    invoke-static {v4}, Lcom/android/server/NotificationManagerService;->access$1300(Lcom/android/server/NotificationManagerService;)V

    goto/16 :goto_12

    .line 1983
    .restart local v12       #audioManager:Landroid/media/AudioManager;
    .restart local v13       #audioStreamType:I
    .restart local v18       #hasValidSound:Z
    .restart local v20       #identity:J
    .restart local v24       #looping:Z
    .restart local v31       #soundUri:Landroid/net/Uri;
    .restart local v35       #useDefaultSound:Z
    :catch_1
    move-exception v4

    .line 1985
    invoke-static/range {v20 .. v21}, Landroid/os/Binder;->restoreCallingIdentity(J)V
    :try_end_10
    .catchall {:try_start_10 .. :try_end_10} :catchall_0

    goto/16 :goto_b
.end method

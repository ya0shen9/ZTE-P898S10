.class Lcom/android/server/pm/HibernateThread$3;
.super Landroid/content/BroadcastReceiver;
.source "HibernateThread.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/server/pm/HibernateThread;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/server/pm/HibernateThread;


# direct methods
.method constructor <init>(Lcom/android/server/pm/HibernateThread;)V
    .locals 0
    .parameter

    .prologue
    .line 311
    iput-object p1, p0, Lcom/android/server/pm/HibernateThread$3;->this$0:Lcom/android/server/pm/HibernateThread;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1
    .parameter "context"
    .parameter "intent"

    .prologue
    .line 314
    iget-object v0, p0, Lcom/android/server/pm/HibernateThread$3;->this$0:Lcom/android/server/pm/HibernateThread;

    invoke-virtual {v0}, Lcom/android/server/pm/HibernateThread;->actionDone()V

    .line 315
    return-void
.end method

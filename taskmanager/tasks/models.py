from django.db import models

class Task(models.Model):
    objects = None
    author_name = models.CharField(max_length=100, verbose_name="Имя автора")
    title = models.CharField(max_length=200, verbose_name="Заголовок задачи")
    description = models.TextField(verbose_name="Описание задачи")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Дата создания")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Дата обновления")
    is_completed = models.BooleanField(default=False, verbose_name="Выполнено")

    def __str__(self):
        return f"{self.title} (автор: {self.author_name})"

    class Meta:
        verbose_name = "Задача"
        verbose_name_plural = "Задачи"
        ordering = ['-created_at']
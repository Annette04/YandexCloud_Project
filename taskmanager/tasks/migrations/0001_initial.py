# Generated by Django 3.2.25 on 2025-05-18 11:08

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Task',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('author_name', models.CharField(max_length=100, verbose_name='Имя автора')),
                ('title', models.CharField(max_length=200, verbose_name='Заголовок задачи')),
                ('description', models.TextField(verbose_name='Описание задачи')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Дата создания')),
                ('updated_at', models.DateTimeField(auto_now=True, verbose_name='Дата обновления')),
                ('is_completed', models.BooleanField(default=False, verbose_name='Выполнено')),
            ],
            options={
                'verbose_name': 'Задача',
                'verbose_name_plural': 'Задачи',
                'ordering': ['-created_at'],
            },
        ),
    ]

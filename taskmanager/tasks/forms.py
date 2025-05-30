from django import forms
from .models import Task

class TaskForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = ['author_name', 'title', 'description', 'image', 'is_completed']
        widgets = {
            'description': forms.Textarea(attrs={'rows': 4}),
        }
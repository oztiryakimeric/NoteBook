from django.contrib import admin
from .models import Faculty, Department, Class, Material, Comment, Favorite, Feedback, Tag, Follower

# Register your models here.

admin.site.register(Faculty)
admin.site.register(Department)
admin.site.register(Class)
admin.site.register(Material)
admin.site.register(Comment)
admin.site.register(Favorite)
admin.site.register(Feedback)
admin.site.register(Tag)
admin.site.register(Follower)
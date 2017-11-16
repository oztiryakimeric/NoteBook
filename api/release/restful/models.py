from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User

class Faculty(models.Model):
    faculty_name = models.CharField(max_length=100)

    def __str__(self):
        return self.faculty_name

class Department(models.Model):
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department_name = models.CharField(max_length=100)
    department_code = models.CharField(max_length=20)

    def __str__(self):
        return self.department_name

class Class(models.Model):
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name="department")
    class_code = models.CharField(max_length=10)
    class_name = models.CharField(max_length=100)

    def __str__(self):
        return self.class_name

class Material(models.Model):
    _class = models.ForeignKey(Class, on_delete=models.CASCADE)
    owner  = models.ForeignKey(User, on_delete=models.CASCADE)
    header = models.CharField(max_length=100)
    description = models.TextField()
    file_url = models.CharField(max_length=200)
    post_date = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.header


class Comment(models.Model):
    material = models.ForeignKey(Material, on_delete=models.CASCADE)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    comment = models.CharField(max_length=140)
    post_date = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.comment

class Favorite(models.Model):
    material = models.ForeignKey(Material, on_delete=models.CASCADE)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return "Some comment..."

class Feedback(models.Model):
    material = models.ForeignKey(Material, on_delete=models.CASCADE)
    point = models.IntegerField()

    def __str__(self):
        return "Feedback with point : " + str(self.point)

class Tag(models.Model):
    material = models.ForeignKey(Material, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)

    def __str__(self):
        return self.name

class Follower(models.Model):
    _class = models.ForeignKey(Class, on_delete=models.CASCADE)
    user  = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return str(self.user) + " following " + str(self._class)
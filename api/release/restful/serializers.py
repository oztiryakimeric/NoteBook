from rest_framework import serializers
from django.contrib.auth import get_user_model # If used custom user model
from .models import Faculty, Department, Class, Material, Comment, Favorite, Feedback, Tag, Follower
from django.core import serializers as serial
from django.db.models import Avg

UserModel = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserModel
        fields = ("id", "username", "first_name", "last_name", "email", "password")

    password = serializers.CharField(write_only=True)

    def create(self, validated_data):
        user = UserModel.objects.create(username=validated_data['username'])
        user.set_password(validated_data['password'])
        user.save()

        return user

    def update(self, instance, validated_data):
        instance.username = validated_data.get('username', instance.username)
        instance.set_password(validated_data.get('password', instance.password))
        instance.first_name = validated_data.get('first_name', instance.first_name)
        instance.last_name = validated_data.get('last_name', instance.last_name)
        instance.email = validated_data.get('email', instance.email)
        instance.save()
        return instance

class FacultySerializer(serializers.ModelSerializer):
    class Meta:
        model = Faculty
        fields = "__all__"

class DepartmentSerializer(serializers.ModelSerializer):
    faculty = serializers.StringRelatedField(many=False)
    classes = serializers.SerializerMethodField("find_classes")

    def find_classes(self, obj):
        deparment_id = obj.id
        class_list = Class.objects.filter(department=deparment_id).order_by("class_name")
        return ClassSerializer(class_list, many=True).data

    class Meta:
        model = Department
        fields = "__all__"

class ClassSerializer(serializers.ModelSerializer):
    department = serializers.StringRelatedField(many=False)
    material_count = serializers.SerializerMethodField('calculate_material_count')

    def calculate_material_count(self, obj):
        class_id = obj.id
        materials = Material.objects.filter(_class=class_id)
        return len(materials)

    class Meta:
        model = Class
        fields = "__all__"

class MaterialSerializer():
    class Get(serializers.ModelSerializer):
        _class = serializers.PrimaryKeyRelatedField(many=False, read_only=True)
        owner = serializers.SlugRelatedField(slug_field='username', read_only=True)
        favorite_count = serializers.SerializerMethodField("calculate_favorite_count")
        comment_count = serializers.SerializerMethodField("calculate_comment_count")
        feedback = serializers.SerializerMethodField("calculate_feedback")
        tags = serializers.SerializerMethodField("find_tags")
        liked = serializers.SerializerMethodField("is_liked")

        def calculate_favorite_count(self, obj):
            material_id = obj.id
            favorites = Favorite.objects.filter(material=material_id)
            return len(favorites)

        def calculate_comment_count(self, obj):
            material_id = obj.id
            comments = Comment.objects.filter(material=material_id)
            return len(comments)

        def calculate_feedback(self, obj):
            material_id = obj.id
            feedbacks = Feedback.objects.filter(material=material_id)
            value = feedbacks.aggregate(Avg('point'))["point__avg"]
            if value == None: return 3
            return value

        def find_tags(self, obj):
            material_id = obj.id
            tags = Tag.objects.filter(material=material_id)
            return TagSerializer.GetForMaterial(tags, many=True).data

        def is_liked(self, obj):
            user_code = self.context.get("user_code")
            result = Favorite.objects.filter(owner=user_code, material=obj.id)

            return len(result) != 0

        class Meta:
            model = Material
            fields = "__all__"

    class Post(serializers.ModelSerializer):
        class Meta:
            model = Material
            fields = ("id", "_class", "owner", "header", "description", "file_url")

        def create(self, validated_data):
            return Material.objects.create(**validated_data)

        def update(self, instance, validated_data):
            instance.header = validated_data.get("header", instance.header)
            instance.description = validated_data.get("description", instance.description)
            instance.file_url = validated_data.get("file_url", instance.file_url)
            instance.save()
            return instance

class CommentSerializer():
    class Get(serializers.ModelSerializer):
        material = serializers.PrimaryKeyRelatedField(many=False, read_only=True)
        owner = serializers.SlugRelatedField(slug_field='username', read_only=True)

        class Meta:
            model = Comment
            fields = "__all__"

    class Post(serializers.ModelSerializer):
        class Meta:
            model = Comment
            fields = ("id", "material", "owner", "comment")

        def create(self, validated_data):
            return Comment.objects.create(**validated_data)

        def update(self, instance, validated_data):
            instance.comment = validated_data.get("comment", instance.comment)
            instance.save()
            return instance

class FavoriteSerializer():
    class Get(serializers.ModelSerializer):
        owner = serializers.SlugRelatedField(slug_field='username', read_only=True)
        material = serializers.SerializerMethodField("find_material")

        def find_material(self, obj):
            material_id = obj.material.id
            material = Material.objects.filter(id=material_id)
            return MaterialSerializer.Get(material, many=True).data

        class Meta:
            model = Favorite
            fields = "__all__"

    class Post(serializers.ModelSerializer):
        class Meta:
            model = Comment
            fields = ("id", "material", "owner")

        def create(self, validated_data):
            return Favorite.objects.create(**validated_data)

class FeedbackSerializer(serializers.ModelSerializer):
    average = serializers.SerializerMethodField("calculate_feedback")

    def calculate_feedback(self, obj):
        material_id = obj.material
        feedbacks = Feedback.objects.filter(material=material_id)
        value = feedbacks.aggregate(Avg('point'))["point__avg"]
        if value == None: return 3
        return value

    class Meta:
        model = Feedback
        fields = "__all__"

class TagSerializer():
    class Get(serializers.ModelSerializer):
        material = MaterialSerializer.Get(many= False, read_only=True)

        class Meta:
            model = Tag
            fields = ("id", "material", "name")
    class GetForMaterial(serializers.ModelSerializer):
        class Meta:
            model = Tag
            fields = ("name",)

















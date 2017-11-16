from django.http import Http404, HttpResponse
from django.shortcuts import render
from rest_framework import permissions
from rest_framework.generics import CreateAPIView
from rest_framework.views import APIView
from django.contrib.auth import get_user_model # If used custom user model
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.response import  Response
from django.contrib.auth import authenticate

from .serializers import UserSerializer, FacultySerializer, DepartmentSerializer, ClassSerializer, MaterialSerializer, CommentSerializer, FavoriteSerializer, TagSerializer, FeedbackSerializer
from .models import Faculty, Department, Class, Material, Comment, Favorite, Tag

class PageInterval():
    PAGE_SIZE = 10;
    def __init__(self, request):
        self.page = request.GET.get("page", -1)
        if(self.page == -1): self.page = 1
        self.start = (int(self.page) - 1) * self.PAGE_SIZE
        self.end = int(self.page) * self.PAGE_SIZE

class ApiHelper():
    @staticmethod
    def get_class_code(request):
        return int(request.GET.get("class_code", "-1"))

    @staticmethod
    def get_user_code(request):
        return int(request.GET.get("user_code", "-1"))

    @staticmethod
    def get_username(request):
        return request.GET.get("username", "-1")

    @staticmethod
    def get_material_code(request):
        return int(request.GET.get("material_code", "-1"))

    @staticmethod
    def for_favorited(request):
        return int(request.GET.get("favorited", "-1"))

    @staticmethod
    def get_comment_code(request):
        return int(request.GET.get("comment_code", "-1"))

    @staticmethod
    def get_favorite_code(request):
        return int(request.GET.get("favorite_code", "-1"))

    @staticmethod
    def get_tag_name(request):
        return request.GET.get("tag_name", "-1")

class LoginView(APIView):

    def get_object(self, password):
        try:
            return User.objects.get(password=password)
        except User.DoesNotExist:
            raise Http404

    def post(self, request):
        user = authenticate(username=request.POST.get("username"), password=request.POST.get("password"))

        if user is not None:
            serializer = UserSerializer(user, many=False)
            return Response(serializer.data)
        else:
            return HttpResponse("fail", status=status.HTTP_400_BAD_REQUEST)

class UserView(APIView):

    def get_object(self, pk):
        try:
            return User.objects.get(pk=pk)
        except User.DoesNotExist:
            raise Http404

    def get_object_with_username(self, username):
        try:
            return User.objects.get(username=username)
        except User.DoesNotExist:
            raise Http404

    permission_classes = [permissions.AllowAny]
    serializer_class = UserSerializer

    def get(self, request):
        user = None

        if ApiHelper.get_username(request) != "-1":
            user = self.get_object_with_username(ApiHelper.get_username(request))
        else:
            user = self.get_object(ApiHelper.get_user_code(request))
        serializer = UserSerializer(user, many=False)
        return Response(serializer.data)

    def post(self, request):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request):
        user = self.get_object(ApiHelper.get_user_code(request))
        serializer = UserSerializer(user, data=request.data)

        if(serializer.is_valid()):
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request):
        user = self.get_object(ApiHelper.get_user_code(request))
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class DepartmentView(APIView):
    def get(self, request):
        interval = PageInterval(request)
        deparments = Department.objects.all().order_by("faculty")[interval.start:interval.end]

        serializer = DepartmentSerializer(deparments, many=True)
        return Response(serializer.data)

class MaterialView(APIView):
    def get_object(self, pk):
        try:
            return Material.objects.get(pk=pk)
        except Material.DoesNotExist:
            raise Http404

    def find_favorited_materials(self, user_code):
        favorites = Favorite.objects.filter(owner=user_code)
        materials = []
        for i in favorites:
            materials.append(i.material)
        return self.delete_duplicates(materials)

    def delete_duplicates(self, materials):
        new_list = []
        for material in materials:
            if not self.has_duplicate(new_list, material):
                new_list.append(material)
        return new_list

    def has_duplicate(self, list, material):
        for i in list:
            if i.id == material.id:
                return True
        return False

    def get(self, request):
        class_code = ApiHelper.get_class_code(request)
        user_code = ApiHelper.get_user_code(request)
        interval = PageInterval(request)
        materials = None
        if(user_code == -1):
            return Http404
        elif(class_code != -1):
            materials = Material.objects.filter(_class=class_code).order_by("header")[interval.start: interval.end]
        else:
            if(ApiHelper.for_favorited(request) == 1):
                materials = self.find_favorited_materials(user_code)
            else:
                materials = Material.objects.filter(owner=user_code).order_by("header")[interval.start: interval.end]

        serializer = MaterialSerializer.Get(materials, many=True, context={'user_code': user_code})
        return Response(serializer.data)

    def post(self, request):
        serializer = MaterialSerializer.Post(data=request.data)

        if(serializer.is_valid()):
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, ):
        material = self.get_object(ApiHelper.get_material_code(request))
        serializer = MaterialSerializer.Post(material, data=request.data)

        if (serializer.is_valid()):
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request):
        material = self.get_object(ApiHelper.get_material_code(request))
        material.delete()

        return Response(status=status.HTTP_204_NO_CONTENT)

class CommentView(APIView):
    def get_object(self, pk):
        try:
            return Comment.objects.get(pk=pk)
        except Comment.DoesNotExist:
            raise Http404

    def get(self, request):
        interval = PageInterval(request)
        comments = Comment.objects.filter(material=ApiHelper.get_material_code(request))[interval.start: interval.end]
        serializer = CommentSerializer.Get(comments, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = CommentSerializer.Post(data=request.data)

        if (serializer.is_valid()):
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request):
        comment = self.get_object(ApiHelper.get_comment_code(request))
        serializer = CommentSerializer.Post(comment, data=request.data)

        if (serializer.is_valid()):
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self):
        comment = self.get_object(ApiHelper.get_comment_code(request))
        comment.delete()

        return Response(status=status.HTTP_204_NO_CONTENT)

class FavoriteView(APIView):
    def get_object(self, pk):
        try:
            return Favorite.objects.get(pk=pk)
        except Favorite.DoesNotExist:
            raise Http404

    def get(self, request):
        favorites = Favorite.objects.filter(owner=ApiHelper.get_user_code(request))
        serializer = FavoriteSerializer.Get(favorites, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = FavoriteSerializer.Post(data=request.data)

        if (serializer.is_valid()):
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request):
        favorites = Favorite.objects.filter(material=ApiHelper.get_material_code(request), owner=ApiHelper.get_user_code(request))
        for favorite in favorites:
            favorite.delete()

        return Response(status=status.HTTP_204_NO_CONTENT)

class FeedbackView(APIView):
    def post(self, request):
        serializer = FeedbackSerializer(data=request.data)

        if (serializer.is_valid()):
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TagView(APIView):
    def get(self, request):
        tags = Tag.objects.filter(name=ApiHelper.get_tag_name(request))
        serializer = TagSerializer.Get(tags, many=True)
        return Response(serializer.data)
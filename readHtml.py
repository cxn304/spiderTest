# -*- coding:UTF-8 -*-
# 用正则修改
import os, re, requests
from bs4 import BeautifulSoup

urls = []
stuPhoto = []
target = 'http://job.lzu.edu.cn/'
path = os.path.abspath('.\\name.txt')
photoPath = os.path.abspath('.\\images')
req = open(path, 'r')
html = req.read()  # str类型数据
div_bf = BeautifulSoup(html, "html.parser")  # BeautifulSoup类型数据
div = div_bf.find_all('div', class_='nr')  # ResultSet类型数据
a = div_bf.find_all('img')  # 找寻照片标签
for each in a:
    urls.append(target+each.get('src'))
stuIdRegex = re.compile(r'\d\d\d\d\d\d\d\d\d\d\d\d')
stuId = stuIdRegex.findall(html)  # 学号，一个列表
dataNumber = len(div)
stuName = []
for i in range(0, dataNumber-4, 5):
    stuName.append(div[i].text + ' ' + div[i+1].text)

if 'images' not in os.listdir():
    os.makedirs('images')

for i in range(len(stuId)):
    stuPhoto = stuName[i] + ' ' + stuId[i]+'.jpg'
    stuPhotoName = os.path.join(photoPath, stuPhoto)
    with open(stuPhotoName, 'wb') as f:
        f.write(requests.get(urls[i]).content)
        f.close()

print('hello')



#nameFile = open(path)
#mcontent = content.replace('"暂无">暂无', '\n')
#print(mcontent)

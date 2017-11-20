# -*- coding:UTF-8 -*-
# 用正则修改
import os, re, requests, time, random
from bs4 import BeautifulSoup

def getproxy(url):
    dl = requests.get(url)
    html = dl.text
    div_bf = BeautifulSoup(html, "html.parser")
    div = div_bf.find_all('td')
    for i in range(100):
        with open('proxyUrl.txt', 'a') as f:
            f.write(div[i].text+' ')
            f.close()

def proxys(ip,port):     #设置代理服务器
    proxyurl = 'http://{0}:{1}'.format(ip, port)
    proxy_dict = {'http': proxyurl}
    return proxy_dict


head = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.86 Safari/537.36',
        'Referer': 'http://job.lzu.edu.cn/',
        'Host': 'job.lzu.edu.cn',
        'Connection': 'keep-alive'}
urls = []
stuPhoto = []
target = 'http://job.lzu.edu.cn/'
path = os.path.abspath('.\\name.txt')
photoPath = os.path.abspath('.\\images')
req = open(path, 'r')
html = req.read()   # str类型数据
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

for i in range(25, len(stuId)):
    stuPhoto = stuName[i] + ' ' + stuId[i]+'.jpg'
    stuPhotoName = os.path.join(photoPath, stuPhoto)
    with open(stuPhotoName, 'wb') as f:
        c = {"http": "http://106.9.170.112:808",
             "https": "http://106.9.170.112:808"}
        try:
            f.write(requests.get(urls[i], proxies=c).content)  # 加上代理服务器
            f.close()
            time.sleep(random.randint(1, 2))
        except :        # 如果遇到错误，可以用一个递归函数来进行
            continue

print('hello')



#nameFile = open(path)
#mcontent = content.replace('"暂无">暂无', '\n')
#print(mcontent)

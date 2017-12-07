# -*- coding:UTF-8 -*-
# 用正则修改
import os, re, requests, time, random
from bs4 import BeautifulSoup


def proxy_File(file):
    F = open(file, 'r')       # 用于找代理服务器
    prox = F.read()
    s = prox.split(',')
    del s[-1]
    proxy = s[random.randint(0, len(s))-1]
    proxies = {'http': proxy,
               'https': proxy}
    return proxies


head = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.86 Safari/537.36',
        'Referer': 'http://job.lzu.edu.cn/',
        'Host': 'job.lzu.edu.cn',
        'Connection': 'keep-alive'}

def download_photo(target):
    urls = []
    path = os.path.abspath('.\\name.txt')
    photoPath = os.path.abspath('.\\images')
    req = open(path, 'r')
    html = req.read()  # str类型数据
    div_bf = BeautifulSoup(html, "html.parser")  # BeautifulSoup类型数据
    div = div_bf.find_all('div', class_='nr')  # ResultSet类型数据
    a = div_bf.find_all('img')  # 找寻照片标签

    for each in a:
        urls.append(target+each.get('src'))  # 照片的url

    stuIdRegex = re.compile(r'\d\d\d\d\d\d\d\d\d\d\d\d')  # 正则表示学号
    stuId = stuIdRegex.findall(html)  # 学号，一个列表
    dataNumber = len(div)
    stuName = []

    for i in range(0, dataNumber-4, 5):
        stuName.append(div[i].text + ' ' + div[i+1].text)

    if 'images' not in os.listdir():
        os.makedirs('images')

    path1 = os.path.abspath('D:\\PycharmProjects\\practice\\canUse.txt')
    proxies = proxy_File(path1)
    i = 22
    while stuId[i]:
        if i == len(stuId)-1:
            break
        else:
            stuPhoto = stuName[i] + ' ' + stuId[i]+'.jpg'
            stuPhotoName = os.path.join(photoPath, stuPhoto)
            if stuPhoto not in os.listdir('D:\\PycharmProjects\\practice\\images'):  # 如果学生不在文件夹里
                with open(stuPhotoName, 'wb') as f:
                    try:  # 如果try子句中的代码导致一个错误，程序执行就立即转到except子句的代码。在运行那些代码之后，继续执行try后的代码。
                        photoContent = requests.get(urls[i], proxies=proxies, timeout=100).content  # 加上代理服务器 .content表示内容
                        f.write(photoContent)  # 如果上一行代码出错，执行完except后还是会执行这一行，即还会把信息写入文件，此时信息是错误的
                        f.close()
                        time.sleep(random.randint(1, 2))
                        if os.path.getsize(stuPhotoName) < 3000:  # 检查，如果相片文件过小，则删除。这是为了删除之前第三句创建的文件
                            os.unlink(stuPhotoName)
                    except:        # 如果遇到错误，执行以下语句
                        print(stuPhoto)
                        path1 = os.path.abspath('D:\\PycharmProjects\\practice\\canUse.txt')
                        proxies = proxy_File(path1)
                        f.close()
                        os.unlink(stuPhotoName)  # 如果出错，因为已经有open语句创建了文件，所以要删除，因为那个文件是空的
                        continue
                    else:    # 如果没有异常，执行以下代码，即i向前推进以便处理下一个学生.else是针对except语句的，所以它会正常输出
                        i += 1
            else:   # 如果学生在文件夹里，则跳到下一个学生继续进行循环
                i += 1



target = 'http://job.lzu.edu.cn/'
download_photo(target)



#nameFile = open(path)
#mcontent = content.replace('"暂无">暂无', '\n')
#print(mcontent)

from bs4 import BeautifulSoup
import requests, re, time, socket


target = 'http://job.lzu.edu.cn/getImr!getStuQzyx.action'
name = []
purl = []
head = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.86 Safari/537.36',
        'Referer': 'http://job.lzu.edu.cn/',
        'Host': 'job.lzu.edu.cn',
        'Connection': 'keep-alive'}  # Host用来伪装
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # 设置等待时间
s.settimeout(100)
req = requests.get(target+'?begin=6&page=1&number=100', headers=head, timeout=100)  # 看google的From Data的view source
req.encoding = 'utf-8'
html = req.text
baconfile = open('name.html', 'wb')
baconfile.write(req.content)   #  注意如果是保存网页或图片或其他二进制文件后面是.content  如果有class对象。则是.iter_content???
div_bf = BeautifulSoup(html, "html.parser")
div = div_bf.find_all('div', class_='nr')
j = 0
for each in div:
    name.append(each)

print(name)

    #j = 0
    #for each in name:
        #name.append(each.string)
        #print(name[j].text)
        #j += 1
        #time.sleep(1)




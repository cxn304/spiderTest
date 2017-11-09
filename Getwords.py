# -*- coding:UTF-8 -*-
from bs4 import BeautifulSoup
import requests
import sys
xinxiName = []
xinxiUrl = []
xinxiNum = 0
if __name__ == '__main__':
    server = 'http://job.lzu.edu.cn/'
    target = 'http://job.lzu.edu.cn/xinxi/'
    req = requests.get(target)
    req.encoding = 'utf-8'
    html = req.text
    div_bf = BeautifulSoup(html, "html.parser")
    div = div_bf.find_all('div', class_='f14 txtLeft')
    a_bf = BeautifulSoup(str(div), "html.parser")
    a = a_bf.find_all('a')

    for each in a:
        print(each.string, server+each.get('href'))
        xinxiName.append(each.string)
        xinxiUrl.append(server+each.get('href'))

number = len(xinxiUrl)
print(number)
print(xinxiUrl)
for uRl in xinxiUrl:   # 每个url中的元素
    req = requests.get(uRl)
    req.encoding = 'utf-8'
    html = req.text
    div_bf = BeautifulSoup(html, "html.parser")
    div = div_bf.find_all('div', class_='seg2_list')
    a_bf = BeautifulSoup(str(div), "html.parser")
    a = a_bf.find_all('a')

    # print('\n\n\n')



    #bf = BeautifulSoup(html, "html.parser")
    #texts = bf.find_all('div', class_='showtxt')
    #print(texts[0].text.replace('\xa0'*8, '\n'))







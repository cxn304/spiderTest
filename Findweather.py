# -*- coding:UTF-8 -*-
from bs4 import BeautifulSoup
import requests
import sys


class downloadLzu(object):

    def __init__(self):
        self.server = 'http://job.lzu.edu.cn/'
        self.target = 'http://job.lzu.edu.cn/xinxi/'
        self.name = []  # 几个大模块的name
        self.url = []   # 几个大模块的url
        self.tName = []  # 单位的name
        self.tUrl = []  # 单位的url
        self.num = 0

    def getDownloadUrl(self):      # 得到几个大模块的信息
        req = requests.get(self.target)  # 'http://job.lzu.edu.cn/xinxi/'
        req.encoding = 'utf-8'
        html = req.text
        div_bf = BeautifulSoup(html, "html.parser")
        div = div_bf.find_all('div', class_='f14 txtLeft')
        a_bf = BeautifulSoup(str(div), "html.parser")
        a = a_bf.find_all('a')
        for each in a:
            self.name.append(each.string)
            self.url.append(self.server+each.get('href'))

    def writer(self,name,path,text):
        write_flag = True
        with open(path, 'a', encoding='utf-8') as f:
            f.write(name+'\n')
            f.writelines(text)
            f.write('**********\n')

    def getUrl(self):   # 每个已经存在url中的元素 target填入self.url
        for i in range(len(self.url)):
            req = requests.get(self.url[i])     # requests.get只能是一个单独的url，不能是列表
            req.encoding = 'utf-8'
            html = req.text
            div_bf = BeautifulSoup(html, "html.parser")
            div = div_bf.find_all('div', class_='seg2_list')
            a_bf = BeautifulSoup(str(div), "html.parser")
            b = a_bf.find_all('a')
            self.num = len(b)
            for each in b:
                if 'htmlfile' in each.get('href'):  # 剔除非学校的信息,需加上.get
                    self.tName.append(each.string)
                    self.tUrl.append(self.server+each.get('href'))


    def getWord(self, target):  # 得到招聘信息
        req = requests.get(target)
        req.encoding = 'utf-8'
        html = req.text
        div_bf = BeautifulSoup(html, "html.parser")
        texts = div_bf.find_all('div', id='jyw_content', class_='seg3_content')
        mtexts = texts[0].text.replace('\n'*4, '\n')   # 必须是列表才能text
        return mtexts


if __name__ == "__main__":
    dl = downloadLzu()
    dl.getDownloadUrl()
    dl.getUrl()
    for i in range(dl.num):
        dl.writer(dl.tName[i], '招聘.txt', dl.getWord(dl.tUrl[i]))
        print('downloading ' + str(i+1) + ' messages')

print('download OK')








# -*- coding:UTF-8 -*-
from bs4 import BeautifulSoup
import requests
import sys
'''
类说明：下载信息 
创建类后和函数非常相似，但是与普通函数不同的是，
它的内部有一个“self”，参数，它的作用是对于对象自身的引用。
'''
class Downloader(object):

    def __init__(self):
        self.server = 'http://job.lzu.edu.cn/#'
        self.target = 'http://job.lzu.edu.cn/xinxi/'
        self.names = []
        self.urls = []
        self.nums = 0


    def get_download_url(self):
        req = requests.get(url=self.target)  # 信息网中找的
        html = req.text
        div_bf = BeautifulSoup(html, 'html.parser')
        div = div_bf.find_all('div', class_='f14 txtLeft')
        a_bf = BeautifulSoup(str(div), "html.parser")
        a = a_bf.find_all('a')
        self.nums = a[:]   # 取页面信息
        for each in a[:]:
            self.names.append(each.string)  # append用来给列表的最后加上值
            self.urls.append(self.server+each.get('href'))  # href一般用来存URL


    def get_words(self,target):
        req = requests.get(url=target)
        html = req.text
        bf = BeautifulSoup(html, "html.parser")
        texts = bf.find_all('div', class_='seg3_content')
        texts = texts[0].text.replace('\xa0'*8, '\n')
        return texts


    def writer(self,name,path,text):
        write_flag = True
        with open(path, 'a', encoding='utf-8') as f:
            f.write(name+'\n')
            f.writelines(text)
            f.write('\n\n')


if __name__ == "__main__":
    dl = Downloader()
    dl.get_download_url()
    for i in range(len(dl.nums)):
        dl.writer(dl.names[i], '牧神记.txt', dl.get_words(dl.urls[i]))
        sys.stdout.write(" 已下载：%.3f%%" % float(i/len(dl.nums))+'\r')
        sys.stdout.flush()
    print('下载完成')












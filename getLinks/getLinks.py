# -*- coding:UTF-8 -*-
import requests, re, time
from bs4 import BeautifulSoup

proxy = 'http://122.72.18.34:80'
proxies = {'http': proxy,
           'https': proxy}

pages = []
def getLinks(pageUrl):
    global pages
    proxy = 'http://122.72.18.34:80'
    proxies = {'http': proxy,
                'https': proxy}
    html = requests.get('http://job.lzu.edu.cn'+pageUrl, proxies=proxies)
    html.encoding = 'utf-8'
    lj = BeautifulSoup(html.text, "html.parser")
    for link in lj.find_all('a', href=re.compile(r'htmlfile')):

        if link.get('href') not in pages:
            newPage = link.get('href')
            if 'http://job.lzu.edu.cn' in newPage:
                tem = newPage[21:]
                print(tem)
                pages.append(tem)
                getLinks(tem)
            else:
                print(newPage)
                pages.append(newPage)
                getLinks(newPage)


getLinks("")

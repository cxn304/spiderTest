# -*- coding:UTF-8 -*-
import requests, os, re
from bs4 import BeautifulSoup

head = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393',
        'Host': 'www.xicidaili.com',
        'Accept': 'text/html, application/xhtml+xml, image/jxr, */*',
        'Accept-Encoding': 'gzip,deflate',
        'Connection': 'keep-alive'
        }  # Host用来伪装
# r = requests.get('http://www.xicidaili.com/', headers=head)
# print(r.text)
# with open('proxy.txt', 'w') as f:
    # f.write(r.text)

def proxy_dict():
    path = os.path.abspath('.\\proxy.txt')
    req = open(path, 'r')
    html = req.read()  # str类型数据
    proxyIp = re.findall(r'\d+\.\d+\.\d+\.\d', html)    # findall适用于文本类型的数据  # 匹配ip地址
    proxyPort = re.findall(r'<td>\d+</td>', html)     # 匹配端口
    pTemp = ''.join(proxyPort)  # join的作用是把列表中的各个值连接起来成一个大字符串
    proxyDict = {}
    proxyDict.setdefault('http', [])
    proxyDict.setdefault('https', [])

    for i in range(len(proxyIp)):
        proxyPort = re.findall(r'\d+', pTemp)  # 从有<td>标签的proxyPort中把端口纯数字提取出来覆盖到proxyPort当中
        proxyUrl = 'http://{0}:{1}'.format(proxyIp[i], proxyPort[i])  # 传给requests的字典，不论http还是https，这里都是'http://{0}:{1}'
        proxyDict['http'].append(proxyUrl)  # 给字典循环赋值
        proxyDict.setdefault('http', [])  # 循环赋值中一定加上这句, setdefault确保了http键存在与字典中
        proxyDict['https'].append(proxyUrl)  # 给字典循环赋值 https
        proxyDict.setdefault('https', [])  # 循环赋值中一定加上这句

    return proxyDict

myDict = proxy_dict()
print(myDict)









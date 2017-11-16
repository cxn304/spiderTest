from bs4 import BeautifulSoup
import requests, re

class Photos(object):

    def __init__(self):
        self.server = 'http://job.lzu.edu.cn/'
        self.target = 'http://job.lzu.edu.cn/getImr!getStuQzyx.action'
        self.name = []  # student's name
        self.url = []   # 几个大模块的url 
        self.num = 0  # stu's number

    def getphoto(self):
        for i in range(10):
            req = requests.get(self.target+'?begin=6&page='+str(i)+'&number=6')
            req.encoding = 'utf-8'
            html = req.text
            div_bf = BeautifulSoup(html, "html.parser")
            name = div_bf.find_all('div', class_='nr')
            j = 0
            for each in name:
                self.name.append(each.string)
                print(self.name[j])
                j += 1


if __name__ == "__main__":
    pt = Photos()
    pt.getphoto()

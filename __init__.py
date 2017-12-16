# -*- coding:UTF-8 -*-
import csv, random, os

def sort(A,c,n):
    for i in range(len(c)-1):
        if A[n] < c[i]:
            c.append('')
            c[i+1:len(c)-1] = c[i:len(c)-2]
            c[i] = A[n]
            break
    return c

def insert(A, c, n):
    if n==-1:
        c.append(A[n])
    else:
        insert(A,c, n-1)  # 把这个看成是已经排号序的n-1个数列
        c = sort(A,c,n)  # 然后对上面数列进行插入A[n]的排序
        print(c)
        print(A[n])

# a = [3,64,32,13,98,45,12]
# c = [99999999]
# n = len(a)
# insert(a,c,n-1)
# print(a[-1])
#################################################################################

def Fibo(n):
    if n < 2:
        return 1
    else:
        b = Fibo(n-1)+Fibo(n-2)
        print(b)
        return b
# Fibo(6)

################################################################################

def find_cross(A, low, mid, high):   # low,high指下标      返回值不对
    maxl = -9999999
    summ = 0
    left = 0
    right = 0
    for i in range(low, mid+1, -1):
        summ = summ + A[i]
        if summ > maxl:
            maxl = summ
            left = i
    maxr = -999999
    summ = 0
    for j in range(mid+1, high):
        summ = summ + A[j]
        if summ > maxr:
            maxr = summ
            right = j
    return left, right, maxl+maxr

def find_max_summary(A, low, high):  # low,high指下标 但是high
    if low == high:
        return low, high, A[low]
    else:
        mid = int((low+high)/2)
        llow,lhigh,lmax=find_max_summary(A, low, mid)
        rlow,rhigh,rmax=find_max_summary(A, mid+1, high)
        left, right, maxx = find_cross(A, low, mid, high)
        if lmax >= rmax and lmax >= maxx:
            return llow,lhigh,lmax
        elif lmax <= rmax and rmax >= maxx:
            return rlow,rhigh,rmax
        else:
            return left,right,maxx
            # print(left,right,maxx)

def xianxing(A):  # 另一种方法
    n = len(A)
    print(n)
    summ = 0
    zmax = -9999
    c = 0
    d = 0
    for i in range(0, n-1):
        summ = summ+A[i]
        if summ > zmax:
            zmax = summ
            c = i
    for j in range(1,c):
        if sum(A[j:n])>zmax:
            zmax = sum(A[j:n])
            d = j
    return d, c, A[d:c+1]

# a = [3,23,-32,20,-3,-2,12,14]
# print(find_max_summary(a,0,7))
# print(xianxing(a))

################################################################################

def proxyFile(file):
    F = open(file, 'r')       # 用于找代理服务器
    prox = F.read()
    s = prox.split(',')
    del s[-1]
    proxy = s[random.randint(0, len(s))-1]
    proxies = {'http': proxy,
               'https': proxy}
    return proxies

# path = os.path.abspath('D:\\PycharmProjects\\practice\\canUse.txt')
# proxies = proxyFile(path)
# print(proxies)

################################################################################
# 用于储存csv文件
def csvFile1():
    import csv

    with open(".\\test.csv", 'w+', newline='') as csvFile:
        try:
            writer = csv.writer(csvFile)
            writer.writerow(('number', 'number+2', 'number time 2'))  # 这个writerow语句有好几个参数
            for i in range(10):
                writer.writerow((i, i+2, i*2))
        finally:
            csvFile.close()


def csvFile2():
    import csv
    with open(".\\test.csv", 'r+', newline='') as csvFile:
        reader = csv.DictReader(csvFile)
        # csv.DictReader会返回把CSV文件每一行转换成Python的字典对象返回，而不是列表对象，并把字段列表保存在变量dictReader.fieldnames里
        for row in reader:
            print(row.items())

# csvFile1()
# csvFile2()


################################################################################
# 清洗数据
def ngram(n):
    from bs4 import BeautifulSoup
    import requests, re

    req = requests.get("http://en.wikipedia.org/wiki/Python_(programming_language)")
    req.encoding = 'utf-8'
    html = req.text
    bsObj = BeautifulSoup(html, "html.parser")
    content = bsObj.find_all("div", class_="mw-parser-output")
    inputs = content[0].text  # find_all的结果要加上text表示里面的内容
    inputs = re.sub('\n+', " ", inputs)
    inputs = re.sub(' +', " ", inputs)

    inputs = inputs.split(' ')
    output = []
    for i in range(len(inputs)-n+1):
        output.append(inputs[i:i+n])
        # output = ''.join(output[i].split())

    print(output)

ngram(2)

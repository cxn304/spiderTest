import re

newPage = 'http://job.lzu.edu.cn/htmlfile/article/read/2014-05/article_45220.shtml'
# a = re.compile(r'http://job.lzu.edu.cn(.*)')
a = 'http://job.lzu.edu.cn'
if a in newPage:
    print(newPage[21:])
    print(len(a))
else:
    print('false')

# -*- coding:UTF-8 -*-
import os
from bs4 import BeautifulSoup

path = os.path.abspath('.\\name.txt')
nameFile = open(path)
content = nameFile.read()
mcontent = content.replace('"暂无">暂无', '\n')
print(mcontent)

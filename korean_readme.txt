[소스코드]
• 데이터톤 내부데이터 전처리 (datathon_data_preprocess.ipynb)
Description
==================================================================
html 형식 데이터 파일을 year/semester/code/sep/department/class_name/professor_name/building/floor/day1/day2/start1/end1/start2/end2 형식의 .csv 파일로 변환했습니다.

r'\w\(\d-\d*\)'로 요일 추출,  r'\d+.호'과 r'B\d+'로 층 추출, r'\w+관'로 건물 추출 후 1차적으로 데이터를 변환했습니다.
r'\d+'로 교시 추출, r'[가-힣]+'로 정확한 요일 추출, len(df['교시'])로 시작1, 끝1, 시작2, 끝2 추출 후 2차적으로 데이터를 변환했습니다.

Prerequisites
==================================================================
python>=3.0.0
import pandas as pd
import re

Usage
==================================================================
df로 raw 데이터 불러오기
전처리.ipynb run (전처리 희망 과에 대해 2차 데이터 변환 코드 돌리기)



• KLUE 데이터 크롤링 (klue_crawling.ipynb)
Description
==================================================================
동적 페이지를 크롤링하기 위해 selenium 패키지를 사용해 KLUE 로그인 사이트에 접속한 뒤, KLUE 아이디와 비밀번호를 입력한 뒤 로그인 버튼을 클릭하도록 했습니다. 각각의 강의 URL로 접속한 다음, xpath 주소를 이용해 강의명과 담당교수명을 크롤링했습니다. 데이터가 없는 경우에는 NULL로 처리해주었습니다. 
KLUE 사이트에서 난이도, 학습량, 학점, 성취감 4개 지표에 대한 수치형 점수를 크롤링했습니다. 또한 강의평가가 있는 컨테이너 정보를 수집한 다음 각 컨테이너마다 학생들이 입력한 강의평 텍스트 데이터를 추출했습니다. 최대 강의평 텍스트 데이터 길이는 50으로 지정해주었습니다. 
크롤링한 강의명, 담당교수명, 4개 지표점수(난이도, 학습량, 학점, 성취감)는 미리 생성해둔 klue_scoring.xlsx에 저장한 뒤, 강의평 텍스트 데이터는 klue_evaluation.xlsx에 저장했습니다. 2개의 xlsx 파일은 하나로 합쳐 최종적인 크롤링 데이터셋 klue_crawling을 생성했습니다.

Prerequisites
==================================================================
python>=3.0.0
import selenium
import chromium-chromedriver
import pandas as pd
import numpy as np
import re



• KLUE 강의평 텍스트 전처리 (evaluation_data_preprocess.ipynb)
Description
==================================================================
팀원들이 나누어 크롤링한 KLUE 강의평 및 항목별 점수에 대한 csv를 통합한 뒤 강의평 텍스트에 대한 전처리를 진행했습니다. 
정규표현식을 이용한 text_cleaning이라는 사용자 함수를 통해 한글과 띄어쓰기를 제외한 모든 글자를 제거해준뒤 evaluation_kor 칼럼에 저장했습니다. 이후 한글 문자만 남긴 텍스트 데이터에 대해, pykospacing 패키지를 이용해 띄어쓰기를 교정했습니다. 

Prerequisites
==================================================================
python>=3.0.0
pip3 install git+https://github.com/haven-jeon/PyKoSpacing.git
import pandas as pd
import re
from pykospacing import Spacing



• KLUE 강의평 텍스트 형태소 분석 (evaluation_data_preprocess_khaiii.ipynb)
Description
==================================================================
정규표현식으로 한글만 남겨두고 pykospacing으로 띄어쓰기를 교정한 수강평 텍스트 데이터에 대해 품사 태깅을 진행해 분석 대상이 될 의미 있는 품사들만 남겼습니다.
khaiii 품사 태깅을 통해 보통명사, 고유명사, 성상 관형사, 동사, 형용사에 해당하는 단어 토큰들만 추출했습니다. 
이후 이 토큰들로부터 정규표현식을 통해 표제어를 추출한다. 불용어까지 제거한 후, 행별로 각 강의의 강의평 단어 토큰을 담은 csv 파일을 생성했습니다. 

Prerequisites
==================================================================
python>=3.0.0
git clone https://github.com/kakao/khaiii.git #git clone
pip install cmake
mkdir build
cd build && cmake /content/khaiii
cd /content/build/ && make all
cd /content/build/ && make resource #리소스 빌드
cd /content/build && make install
cd /content/build && make package_python #파이썬 바인딩
pip install /content/build/package_python



• 가중치 부여 알고리즘 (weight_algorithm.ipynb)
Description
==================================================================
첫번째 ‘과목명, 교수명, 선호도 입력’은 사용자가 듣고 싶은 강의명, 담당교수명과 가중치를 입력시 해당 강의의 최종 가중치를 출력하는 코드입니다. 
- set_info() 함수: 
입력받은 강의명, 교수명을 이용해 klue_crawling.xlsx에서 매칭되는 데이터를 찾음
해당 강의의 4개 지표값과 입력받은 4개 지표 가중치값을 곱해 최종 가중치 계산

세번째 ‘입력 선호도에 따른 시간표 후보 가중치’는 시간표 후보 1개의 전체적인 가중치를 계산하는 코드입니다. 
- set_info() 함수: 
이중 딕셔너리 구조를 이용해 시간표 후보(candiate_1)과 시간표 후보(candidate_2)를 임의로 설정
4개 지표(난이도, 학습량, 학점, 성취감)마다 빈 리스트 정의
for 반복문을 이용해 하나의 시간표 후보마다 포함된 1개의 강의마다 4개 지표값 추출
사용자가 입력한 가중치와 곱해 최종 가중치 계산

Prerequisites
==================================================================
python>=3.0.0



• 시간표 추천 알고리즘 (recommendation_timetable.R)
Description
==================================================================
임의로 10개의 수업을 입력 받을 때 겹치지 않는 6개의 수업으로 구성된 시간표를 짜는 알고리즘
유전 알고리즘의 경우 각 수업마다 정해진 시간에만 열리는 제약 조건을 효율적으로 고려할 수 없기 때문에 계산 효율성을 극대화할 수 있는 알고리즘이 필요해졌습니다.

timetable=array(0, c(8, 5, 210)) 선언 후 10개의 수업 중 6개를 선택하는 combn(10, 6)=210개의 경우의 수를 계산
for문을 통해 6개의 수업을 순차적으로 timetable에 입력
만약 이전 입력된 수업과 요일과 시간이 겹친다면 mat[9, 9]에 입력
8×5 행렬로 crop 후 unique한 수업의 수가 6일 때만 timetable에 저장
timetable 중 zero matrix인 경우 제외 후 최종 가능 시간표들 출력

Prerequisites
==================================================================
R>=3.6
library(tidyverse)
library(combinat)

Usage
==================================================================
희망하는 수업 10개를 data.frame 형태로 저장
time_scheduler 함수에 10개 수업에 대한 data frame을 입력



• 연강 (consecutive_classes.ipynb, consecutive_classes.R)
Description
==================================================================
- consecutive_classes.ipynb
요일과 시간 교시에 대해 정수 코딩 진행
요일별로 1-5까지 정수 부여, 각 교시 별로 1-8까지 정수 부여

- consecutive_classes.R
2개씩 수업을 선택해서 연강인지 판단한 후 class1/class2/building1/building2/floor1/floor2 형태로 csv 파일 출력
for 반복문에서 정수 인코딩된 시간의 차가 1일 때 (=연강일 때) 요일이 같은 경우일 때 추출

Prerequisites
==================================================================
python>=3.0.0
import pandas as pd
import re

R>=3.6
library(tidyverse)
library(googledrive)

Usage
==================================================================
연강 여부를 알고 싶은 수업들을 연강.ipynb에서 csv형식으로 불러오기
각 column별 정수 인코딩된 csv 파일을 google drive에 csv 형식으로 저장
drive_find()를 통해 google drive에 저장된 csv 파일 이름 검색 후 연강.R run 



• 강의별 워드클라우드 (wordcloud_visualization.ipynb)
Description
==================================================================
강의 별로 수강평 텍스트를 전처리해두었던 klue_khaiii.csv 파일을 불러와서 강의별로 토큰을 리스트에 저장
모든 수강평에 자주 등장해 각 강의의 특성을 보여주기에는 적합하지 않다고 생각되는 단어들은 불용어로 지정해주어 워드 클라우드 생성 시 제외될 수 있도록 했습니다.
사용자정의함수인 lecture_wc에 각각의 강의 index를 입력하면 해당 강의에 대한 워드클라우드 생성

Prerequisites
==================================================================
python>=3.0.0
import pandas as pd
import re
import operator
from wordcloud import WordCloud
import matplotlib.pyplot as plt



• 강의별 연관키워드 분석 (apriori_visualization.ipynb)
Description
==================================================================
한글이 포함된 network 그래프를 출력하기 위해 폰트 관련 세팅을 해주고 텍스트 전처리를 위한 khaiii 패키지를 설치했습니다.
Apriori 알고리즘의 경우, 각 강의의 강의평 안에서 transaction들을 고려해주어야 하기 때문에 별도의 전처리 과정을 거쳤습니다. 
KLUE 사이트에서 크롤링한 그대로의 raw text data에서 한글과 띄어쓰기, 줄바꿈만을 남겨두었습니다.
그리고 강의 별로 엔터를 기준으로 한 줄 씩 한 transaction을 이루는 list가 되도록 형태를 바꾸어주었습니다.
각 강의별로 transaction들이 형성된 상태에서, 각 transaction에 대해 khaiii 패키지를 이용한 품사태깅을 진행하고 어간을 추출한 뒤 불용어를 제거하는 과정을 거쳤습니다.
이렇게 각 강의별로 transaction을 만들고 품사 태깅, 어간 추출, 불용어 제거 등을 하는 과정을 preprocessing()함수로 정의했습니다. 
Apriori 알고리즘에 기반한 네트워크 그래프를 그리기 위해서는 network( ), node( )라는 데이터 프레임 생성 사용자 정의 함수를 만들었습니다. 
network( )는 apriori 알고리즘에 따라 아이템 간의 support, lift, confidence를 계산하고 이 중 중심이 되는 source, source와 연결되는 target, 둘 간의 support를 데이터프레임에 저장하도록 했습니다. 
node( )는 각 강의의 강의평 데이터에 등장한 단어들과 그 단어들의 빈도를 데이터프레임으로 저장할 수 있도록 한 함수입니다. 
이후 vis_apriori 함수로 네트워크 그래프를 그렸습니다. 이 때, k로 노드들 간의 거리를 설정할 수 있고, iter로  iterations of spring-force relaxation 수를 조정할 수 있습니다. 


Prerequisites
==================================================================
python>=3.0.0
!git clone https://github.com/kakao/khaiii.git #git clone
!pip install cmake
!mkdir build
!cd build && cmake /content/khaiii
!cd /content/build/ && make all
!cd /content/build/ && make resource #리소스 빌드
!cd /content/build && make install
!cd /content/build && make package_python #파이썬 바인딩
!pip install /content/build/package_python

import re
import pandas as pd
import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from apyori import apriori





[데이터 파일목록]
• klue_crawling.xlsx
Description
=====================================================================================
사이트에서 경영학과 전공, 전기전자공학부 전공과 핵심교양의 강의명, 담당교수명, 강의평 텍스트 데이터, 난이도/학점/학습량/성취감 4개 지표에 대한 수치형 점수를 크롤링해온 데이터셋입니다. (2021년 7월 15일 기준)


• building_time.xlsx
Description
=====================================================================================
카카오 지도 API를 활용해서 수집한 교내 건물간 이동시간 데이터셋입니다. 
building_1이 출발건물, building_2가 도착건물, b_time은 분 단위로 계산된 이동시간입니다. 


• consecutive_classes_list.xlsx
Description
=====================================================================================
연강인 경우 이동시간을 고려해주기 위해 강의 데이터셋에서 강의를 2개씩 묶어 쌍을 만들어준 뒤, 2개 강의의 건물명과 층을 수집한 데이터셋입니다.
class1이 첫번째 강의명, building1과 floor1이 해당 강의의 건물명과 층 수입니다. class2가 두번째 강의명, building2와 floor2가 해당 강의의 건물명과 층 수입니다.


• class_feature.csv
Description
=====================================================================================
데이터톤에서 제공받은 내부데이터에 전처리를 진행해 각 강의명마다 요일과 교시, 층, 건물을 추출한 데이터셋입니다. 지하1층인 경우 층을 ‘B1’으로 표기했습니다.


• korean_stopwords.txt
Description
=====================================================================================
KLUE에서 크롤링한 강의평 텍스트 데이터 전처리시 사용한 한국어 불용어 모음집입니다. 해당 파일에 있는 불용어는 강의평에서 제거했습니다.


• evaluation_preprocessed.xlsx
Description
=====================================================================================
KLUE에서 크롤링한 강의평 텍스트 데이터에 대해 1번째로 정규표현식을 이용해 한글만 남겨둔 것이 evaluation_kor 컬럼, 2번째로 pykospacing과 pyhanspell을 이용해 띄어쓰기와 맞춤법 교정을 한 데이터가 evaluation_spacing 컬럼, 마지막으로 단어를 토큰화시킨 뒤 특정 품사만 남겨둔 것이 preprocessed 컬럼입니다. 

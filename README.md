<h1> timetable-optimization </h1>
<p align="left">
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=Python&logoColor=white"/></a>&nbsp 
  <img src="https://img.shields.io/badge/R-276DC3?style=flat-square&logo=R&logoColor=white"/></a>&nbsp
</p>
<b><i>Timetable optimization</i></b> is a timetable generator that builds timetable according to the user's preference. The preference can be determined by the course evaluation, distance between the classrooms and more. We built our novel algorithm to recommend list of courses according to the input preferences.
<br>

<h2> major Contributions </h2>

- Collection of travel time between each building through Kakao API
- Crawling data from Korea university course evaluation website: https://klue.kr/
- Preprocessing course evaluation text data (regular expression, Pyhanspell, Pykospacing, stopwords, khaiii)
- Creation of algorithm giving weights for each courses
- Creation of **_timetable generator algorithm_**
- Association rule analysis based on **_Apriori algorithm_**
- Wordcloud visualization
- **_UI/UX storyboard creation_**

<h2> Directory </h2>

### _crawling_
- **klue_crawling**: KLUE(고려대학교 강의평가 사이트)에서 강의평, 학점/학습량/난이도/성취감 4개 지표 데이터 크롤링

### _preprocessing_
- **datathon_data_preprocess**: 데이터톤측에서 제공한 교내 강의데이터 전처리
- **evaluation_data_preprocess**: 클루 강의평 텍스트 데이터 전처리
- **evaluation_data_preprocess_khaiii**: 클루 강의평 텍스트 데이터 형태소 분석 (khaiii)
- **consecutive_classes**: 강의별 요일/교시 정수 인코딩

### _algorithms_
- **consecutive_classes**: 연속되는 강의 분별하는 알고리즘
- **weight_timetable**: 사용자가 입력하는 요소에 따라 시간표 후보에 가중치 부여하는 알고리즘
- **recommendation_timetable**: 시간표 후보 중 최적 시간표 추천하는 알고리즘
- **apriori_visualization**: Apriori 알고리즘을 이용한 연관키워드 시각화
- **wordcloud_visualization**: 강의별 워드클라우드 시각화

### _data_
- **building_time**: 건물간 이동소요시간
- **klue_crawling**: 클루에서 웹 크롤링한 데이터
- **evaluation_preprocessed**: 전처리한 클루 강의평 데이터

### _reports_
- **README(kor)**: 각 소스코드와 데이터에 대한 설명
- 1차 발제 자료
- 2차 발제 자료
- 최종 결과보고서

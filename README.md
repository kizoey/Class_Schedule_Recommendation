## Timetable_Recommendation
- <b>프로젝트 개요:</b> 고려대학교에서 주최하는 'KU 데이터톤'에 출전해 강의평, 강의실간 이동거리를 기반으로 최적의 시간표 추천 서비스 개발
- <b>프로젝트 진행기간:</b> 2021.06.28 - 2021.08.13
- <b>사용언어:</b> Python, R
- <b>역할:</b> 팀장, 카카오 API를 이용한 이동시간 데이터 수집, 강의평 사이트에서 데이터 크롤링, 강의평 텍스트 데이터 전처리(정규표현식, Pyhanspell, Pykospacing, 불용어, khaiii 형태소 분석기), 연속되는 강의 분리하는 알고리즘 개발, 시간표마다 가중치 부여하는 알고리즘 개발, Apriori 알고리즘을 이용한 연관분석, 워드클라우드 시각화
- <b>결과:</b> 

### 자료
- 1차 발제 자료
- 2차 발제 자료
- 최종 결과보고서
- 노션 링크(회의록, 선행 연구 스터디): www.notion.so/caramel-scourge-d0f


### 깃 파일
- klue_crawling: 클루(고려대학교 강의평가 사이트)에서 강의평, 학점/학습량/난이도/성취감 4개 지표에 대한 데이터 크롤링
- datathon_data_preprocess: 데이터톤측에서 제공한 교내 강의데이터 전처리
- evaluation_data_preprocess: 클루 강의평 텍스트 데이터 전처리
- consecutive_classes: 연속되는 강의 분별하는 알고리즘
- weight_timetable: 사용자가 입력하는 요소에 따라 시간표 후보에 가중치 부여하는 알고리즘
- recommendation_timetable: 시간표 후보 중 최적 시간표 추천하는 알고리즘
- apriori_visualization: Apriori 알고리즘을 이용한 연관분석, 워드클라우드 시각화

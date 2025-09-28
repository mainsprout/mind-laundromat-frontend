# mind_laundromat (frontend)

## Project Overview

심리치료 기반 감정관리 앱 "마음 세탁소"의 프론트엔드 프로젝트 입니다. 이 앱은 Flutter를 이용해 개발되었습니다.

## Preparations

ndk 27.0.12077973 needs to be installed
api_service.dart : baseUrl을 본인의 디바이스나 서버에 맞춰 변경 필요

## Project Components (Screens)

**로그인&홈화면**
- start_screen.dart : 첫 화면. 로그인이 되어 있지 않다면 login_screen.dart 으로, 로그인이 되어 있다면 home_screen.art 로 이동.
- login_screen.dart : 로그인 전 sign-in 또는 sign-up으로 이동하는 화면. 
- sign_in_screen.dart : 로그인 화면
- sign_up_screen.dart : 회원가입 화면
- forgot_password_screen.dart : 비번 찾기 화면. 추가예정
- home_screen.art : 홈 화면. 캘린더 아이콘 클릭 시 calendar_screen.dart로, 프로필 아이콘 클릭 시 faq_screen.dart로, 중앙의 이미지 클릭 시 distortion_detail.dart로, 하단의 버튼 클릭 시 select_emotion_screen.dart로 이동.

**다이어리**
- calendar_screen.dart : 캘린더와 함께 선택된 날짜의 다이어리 요약본을 보여주는 화면. 다이어리를 누르면 diary_detail_screen.dart로 이동
- diary_detail_screen.dart : 다이어리 상세 페이지

**상담**
- select_emotion_screen.dart : 채팅 전 현재 감정 선택 창. 선택 후 채팅화면으로 이동.
- counsel_screen.dart : 상담봇과의 채팅화면. 종료시 현재 정보를 가지고 새 다이어리가 만들어짐. diary_detail_screen.dart로 이동.

**인지왜곡카드**
- distortion_detail.dart : 인지왜곡 카드를 보여주는 이미지. 각 카드에는 유저의 해당 인지왜곡 비율이 들어있음.

**프로필**
- profile_screen.dart : 프로필 화면. 본인의 정보를 수정하거나 로그아웃, 계정 삭제 등을 할 수 있음.
- faq_screen.dart : faq 화면. 추가예정.

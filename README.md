# 붕세권

## 참여자 목록
```
- 기획 : 성단빈, 강지현
- 디자인 : 강지현
- 개발자 : 성단빈
```

## 프로젝트 정의
```
- 길거리에서 판매하는 빵가게 포장마차 위치를 알려주는 서비스
```
## 프로젝트 목표
```
- 길거리빵 가게의 위치를 원하는 곳 주변에서 찾을 수 있다.
- 알고있는 (혹은 발견한) 길거리 빵 가게의 위치를 업로드할 수 있다.
- 자주방문하는 길거리 빵 가게를 즐겨찾기 할 수 있다.
- 댓글을 통해 해당 가게의 정보를 다른 사용자와 소통할 수 있다.
```
## Architecture
```
- MVC
```

## Requirements
```
- Language
    - Swift 5.0

- FramWork
    - UIKit

- IDE
    - Xcode
```

## 1차 기획안
```
1- 스플래시
2- 위치설정
3- 홈(지도)
4- 제보
5- 제보완료
6- 마이페이지
```

* 1차 기획 UI

<img src = "https://github.com/danbin920404/BungsegwonPortfolio/blob/main/image/UI_1.png" width = "600" height = "400" />

## 2차 기획안

* FlowChart

<img src = "https://github.com/danbin920404/BungsegwonPortfolio/blob/main/image/FlowChart.png" width = "800" height = "550" />

* 2차 기획 UI
	* Android, iOS

<img src = "https://github.com/danbin920404/BungsegwonPortfolio/blob/main/image/UI_2.png" width = "800" height = "550" />

## 구현 내용
```
- 1. Launch Screen
	- Network가 연결되지 않았다면 alert를 띄워주고 네트워트가 연결될 때까지 재귀적으로 계속 띄움
	- Network가 연결이 되었다면 
		- 1. Map에 마커를 찍을 데이터를 받아옴(앱 배포 초기이므로 가게 수가 적어 전체적으로 많아 보이기 위해 전국의 가게 데이터를 받아옴)
		- 2. 로그인이 되어 있다면 내가 찜한 가게, 내가 등록한 가게, 내가 쓴 댓글 받아오기

- 2. MainVC(Map)
	- 사용자의 위치를 받아 오고 표현할 수 있게 사용자의 동의를 받음.
	- Network통신으로 받아온 맵에 표시할 데이터를 이용해 마커를 찍어주고 클릭 했을 때를 생각하고 콜백함수 구현
	- 사용자가 원하는 위치를 볼 수 있게 카카오 우편서비스 api를 사용
	- 내 위치로 바로 갈 수 있는 버튼 구현
	
- 3. 상세페이지
	- Network통신으로 저장되어 있던 가게ID를 통해 가게 데이터를 받아옴
		- 1. 위경도, 등록,수정일, 메뉴, 가격, 주소, 상세정보를 받아옴
	- 상세페이지가 열리면 Network통신으로 댓글을 받아옴
	- 수정, 찜, 댓글에 기능을 사용할 수 있음
		- 로그인이 되어 있다면 Network통신으로 해당 데이터를 전송하고, 로컬 데이터에 추가
	- 수정, 찜, 댓글의 기능을 사용하려면 로그인이 되어 있어야 하고 로그인이 되어 있지 않다면 회원가입화면으로 이동

- 4. 마이페이지
	- 로그인이 되어 있었다면 Launch Screen에서 받아온 데이터로 찜한 가게, 등록한 가게, 쓴 댓글 collectionView, tableView에 표현
	- 1. 상단에 닉네임을 클릭할 경우 내 정보 수정으로 이동
		- 1. 닉네임 수정 가능
			- 변경하려는 닉네임이 기존 회원들의 닉네임과 중복인지 확인
				- 1. 중복이라면 다른 닉네임을 사용하라는 alert를 띄움
				- 2. 중복이 아니라면 닉네임이 변경됨
		- 2. 내가 회원가입한 sns 이메일을 표시
		- 3. 로그아웃 기능
		- 4. 회원탈퇴 기능
			- 회원탈퇴시 기존에 있던 데이터를 Network통신으로 삭제
			
	- 2. 오른쪽 상단 설정
		- 1. 개인정보처리방침
			- 앱 배포시 연결해줘야 하는 웹으로 구현한 개인정보처리방침을 연결
		- 2. 이메일 문의하기
			- iOS사용자는 기본으로 Mail어플이 깔려 있어 연동을 시켜주고 개발자 본인의 이메일로 바로 보낼 수 있게 구현
		- 3. 오픈 소스 라이브러리
			- 붕세권을 개발하면서 사용한 오픈소스를 표현
			
	- 3. 상세페이지로 이동
		- 간단하게 표현한 찜, 등록한 가게, 쓴 댓글을 선택하면 상세페이지로 이동할 수 있게 구현
			- 기존에 받아온 데이터가 있는 지 확인 후 없다면 Network통신으로 받아옴
	
	- 4. 더보기
		- 조금 더 상세하게 볼 수 있게 구현
		- 위와 동일하게 간단하게 표현한 찜, 등록한 가게, 쓴 댓글을 선택하면 상세페이지로 이동할 수 있게 구현
			- 기존에 받아온 데이터가 있는 지 확인 후 없다면 Network통신으로 받아옴
		- 더이상 필요하지 않은 찜, 등록한 가게, 쓴 댓글 삭제 가능
			- 기존에 있던 데이터를 Network통신으로 삭제

- 5. 가게 등록하기
	- 필수적으로 작성해야 하는 부분을 빨간색으로 구분
	- 가게 이름
		- 가게 이름을 설정하지 않으면 메인메뉴 이름으로 등록
	- 가게 위치
		- 사용자가 직접 드레그해서 위치를 지정할 수 있고 주소검색으로 위치를 지정할 수 있음
	- 상세 위치
	- 메뉴 카테고리
		- 처음 선택한 메뉴가 메인메뉴가 되고 아래에 상세하게 적을 수 있는 맛, 수량, 가격이 나타남
		- 해당 메뉴의 목록을 추가할 수 있는 기능 구현
	- 상세 설명
		- 등록하려는 가게의 정보를 상세하게 적어둘 수 있는 textView 구현
	- 등록하기
		- 필수적으로 작성해야하는 데이터를 모두 작성했다면 등록
			- 1. Network통신으로 등록한 가게의 데이터를 보냄
			- 2. MainVC Map에 마커를 표현해 줌
		- 필수적으로 작성해야 하는 데이터가 작성이 되지 않았다면 textfeild에 테두리를 빨간색으로 변경

- 6. 회원가입 및 로그인
	- 애플, 구글 sns로그인 및 회원가입 기능
		- 1. 해당 sns에 이메일과 비밀번호를 입력하고 로그인이 되어있다면 로그인을 하고 기존에 보고 있던 페이지로 이동하고 Network통신으로 찜, 등록한 가게, 쓴 댓글 받아옴
		- 2. 기존 회원이 아니라면 닉네임 설정 페이지로 이동
			- 설정한 닉네임이 중복인지 확인 후 회원가입 완료
			- 닉네임을 작성하지 않을 경우 빨간색으로 표현
			- 유저의 정보를 Network통신으로 보냄
```

- 기능구현 및 뷰 완성마다 커밋을 남기고 싶었으나 api키 및 sdk키가 노출될 수도 있다고 판단되어 커밋을 남기지 않고 로컬에 폴더를 나눠서 구현을 했습니다 양해 부탁드립니다.

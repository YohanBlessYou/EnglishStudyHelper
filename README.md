# EnglishStudyHelper

## Issue

### 1. 백업 서비스 변경 (구글 드라이브 API -> Dropbox
- 문제
   - 구글 드라이브는 OAuth를 일반 유저들에게 공개하기 위해선 인증 절차가 복잡하다
   - OAuth를 등록하려는 유저에게 App 설명 홈페이지를 만들고 이를 구글로부터 승인받아야 한다
- 해결
   - ios 레퍼런스가 적어 며칠간 고생한게 아깝지만.. Dropbox로 변경

### 2. 동일한 데이터를 참조하는 여러 Scene간 동기화 (feat. MVVM)
- 문제
  - "한국어-영어" 형태로 저장된 Sentence 데이터는 App에서 사용하는 가장 중요하면서 대부분의 scene이 공유된다
  - 동기화 문제가 발생하지 않으면서 확장/변경이 불편하지 않은 구조를 만드는 것이 필요
- 해결
  - 누군가 Model을 변경하면 Notification을 전파하는 구조로 설계
<img width="663" alt="image" src="https://user-images.githubusercontent.com/39155090/159166390-797a4d41-4fbf-41f8-8e99-e243800f2571.png">


# CleanArchitecture
## 💡 프로젝트 주제

- 현재 상영중인 영화 살펴보기.
- 현재 상영중인 영화 리스트 가져오기 API 및 상세 영화 가져오기 API를 통해 네트워크 통신.
- 유저가 앱을 키면, 상영중인 영화 리스트가 나옴.
- 리스트의 영화를 선택하면 상세정보가 나옴.
- 탭바의 '저장'버튼을 클릭하면 로컬 저장소에 저장 되고, 보관함 화면에서 저장된 영화 정보 리스트가 나옴.
- 페이징 처리 및 Swipe를 통한 뷰 새로고침.
- 인터넷 연결이 없는 경우 캐싱된 상영 중인 영화 정보 리스트 노출.

## 💡 사용하고자 하는 기술
- MVVM
- CleanArchitecture
- Repository pattern ( Remote / Local )
- Dependency injection ( [Swinject](https://github.com/Swinject/Swinject) )
- DataBinding( [RxSwift](https://github.com/ReactiveX/RxSwift) )
- Local Database ( [RxCoreData](https://github.com/RxSwiftCommunity/RxCoreData) )

## 💡 프로젝트 개발 진행방식
1. MVVM 패턴을 적용하여 개발한다.
2. CleanrArchitecture 리팩토링 한다. 


## 💡 MVVM ([MVVM branch](https://github.com/Gooreum/CleanArchitecture/tree/MVVM+Rx))
### **MVVM Dependency Map**

![1](https://user-images.githubusercontent.com/48742165/140517457-96d81e75-2293-4207-a289-1caa1d9d9c8b.png)

![2](https://user-images.githubusercontent.com/48742165/140517476-8f9d5256-455b-41e6-9b54-ee96e6d42bb2.png)

### **View**

- 화면 데이터 입출력 및 사용자 인터렉션을 담당합니다.
- 비즈니스 로직 처리는 ViewModel에게 위임합니다.
- RxSwift를 이용하여 ViewModel을 구독하고 ViewModel 연산 결과값을 전달받아 화면에 필요한 데이터를 바인딩해줍니다.

### **ViewModel**

- 앱의 비즈니스로직 처리를 담당하며 View와의 의존성이 전혀 없습니다.
- RxSwift를 이용하여 ViewModel을 구독한 View에게 비즈니스로직 처리 결과 값을 Notify 해줍니다.
- Remote / 영속성 데이터 처리를 위한 작업은 각각 RemoteDataSource / LocalDataSource에게 위임합니다.
- 인터페이스인 RemoteDataSource / LocalDataSource를 의존하게 하게 하고 Main에서 각 인터페이스를 구현하는 구체 클래스(RemoteDataSourceImpl, LocalDataSourceImpl)를  주입해줌으로써 DIP(의존성 역전 원칙)을 구현하였습니다.

### **Model**

- Remote / 영속성 데이터 처리를 위한 로직 처리를 담당합니다.
- RxSwift를 이용하여 자신을 구독하고 있는 ViewModel에게 연산 처리 결과를 Notify 해줍니다.


## 💡 **CleanArchitecture ([CleanArchitectrue branch](https://github.com/Gooreum/CleanArchitecture/tree/CleanArchitecture))**
### **CleanArchitecture Dependency Map**

- 변화가 많은 하위 컴포넌트인 Prersentation Layer와 Data Layer의 의존성이 상위 컴포넌트인 Domain Layer를 향합니다.

![3](https://user-images.githubusercontent.com/48742165/140517495-7cca775c-997c-43b3-a37c-dbf39e519498.png)

### **Presentation Layer**

- 실제 뷰를 보여주기 위한 컴포넌트들을 모아놓은 레이어 입니다.
- 뷰에서 발생한 이벤트를 Domain Layer에 전달하고, Domain Layer로부터 데이터를 받아 뷰를 보여주는 역할을 진행합니다.
- ViewModel은 MVVM에서 비즈니스 로직 처리를 담당하였으나, CleanArchitecture에서는 Domain Layer에게 단순히 로직 처리를 위한 데이터를 전달하거나, Domain Layer에서 처리한 결과를 View에 필요한 형식의 데이터를 가공해주는 역할만 담당합니다.
    - CleanArchitecture에서 Presentation Layer와 Domain Layer간 데이터 통신은 Controller와 Presentation을 통해 이루어지지만 편의상 두 개념을 합친 ViewModel로 구현하였습니다.
- ViewModel은 비즈니스 로직 처리를 Domain Layer의 UseCase에게 위임합니다.
    - DIP구현을 위해 인터페이스인 UseCase를 의존하고 Main에서 UseCaseImpl을 주입하여 느슨한 관계를 만들었습니다.
    - 데이터 통신은 UseCase가 참조하는 Request Model과 Response Model을 통해 이루어집니다.

### **Domain Layer**

- 엔티티와 유즈케이스를 정의 해 놓은 컴포넌트들을 모아놓은 레이어 입니다.
- Presentation Layer로 부터 발생한 이벤트를 Data Layer에 전달하고, Data Layer로부터 데이터를 받아 Presentation Layer로 전달하는 역할을 진행합니다.
- Repository를 통해 Data Layer와 소통하고, UseCase를 통해 Presentation Layer와 소통합니다.
- 비즈니스 업무 규칙을 담당하는 최상위 컴포넌트인 Domain Layer에서는 어떠한 하위 컴포넌트에 의존해서는 안됩니다.
    - 따라서 Domain Layer에서는 Data Layer의 데이터를 가져오더라도 Remote/Local에서 가지고 오는지 여부를 알면 안되기 때문에 Repository 패턴을 적용하였습니다.

### **Data Layer**

- 실제 비즈니스 로직들을 처리하는 컴포넌트를 모아놓은 레이어 입니다.
- 실제 데이터를 가져오거나, 저장하는 역할을 진행합니다.

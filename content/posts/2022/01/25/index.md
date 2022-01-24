---
title: "Java の Stream メモ"
slug: "java-stream-memo"
date: 2022-01-24T22:00:00+09:00
draft: false
categories: ["Java"]
tags: ["Java 8"]
---

## Stream とは

Java 8 から追加され、コレクションに対する集約操作をサポートした機能を持つ。

中間操作と終端操作を組み合わせてパイプラインにできるため、for 文による繰り返し処理を簡潔に記述できる。

## サンプルクラス

### User クラス

年齢と名前の情報のみを持つ、以下のユーザクラスを用いる。

```java
public class User {
    private String name;
    private int age;

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String toString() {
        return "name: " + name + ", age: " + age;
    }
}
```

### User のコレクション

コレクションは以下とする。

```java
List<User> userList = new ArrayList<User>();
userList.add(new User("John", 40));
userList.add(new User("Paul", 79));
userList.add(new User("George", 58));
userList.add(new User("Ringo", 81));
```

## 要素を順番に処理

### forEach

```java
userList.stream()
        .forEach(u -> System.out.println(u));
// name: John, age: 40
// name: Paul, age: 79
// name: George, age: 58
// name: Ringo, age: 81

// 以下も同じ結果
userList.stream()
        .forEach(System.out::println);
```

ラムダ式を受け取るが、別のメソッドをそのまま呼び出す場合、メソッドのみを渡すこともできる。

## 順次/並列

### stream

ストリームは明示的に並列を指定しない限り、順次で実行される。

```java
// stream
userList.stream()
        .forEach(System.out::println);
// name: John, age: 40
// name: Paul, age: 79
// name: George, age: 58
// name: Ringo, age: 81
```

### parallelStream

並列で実行する場合は、並列のストリームを生成する必要がある。

```java
// parallelStream
userList.parallelStream()
        .forEach(System.out::println);
// name: George, age: 58
// name: Ringo, age: 81
// name: John, age: 40
// name: Paul, age: 79
```

## 絞り込み

### filter

与えられたラムダ式が true となる要素から構成された stream を返す。

```java
// 60歳未満のみ出力
userList.stream()
        .filter(u -> u.getAge() < 60)
        .forEach(System.out::println);
// name: John, age: 40
// name: George, age: 58
```

## 加工

### map

与えられたラムダ式で加工した結果から構成される stream を返す。

```java
// "My name is XX" の文字列に加工して出力
userList.stream()
        .map(u -> "My name is" + u.getName())
        .forEach(System.out::println);
// My name isJohn
// My name isPaul
// My name isGeorge
// My name isRingo
```

## スキップ

### skip

先頭から n 番目の要素を除いた stream を返す。

```java
userList.stream()
        .skip(2)
        .forEach(System.out::println);
// name: George, age: 58
// name: Ringo, age: 81
```

この例の場合、John と Paul の2人がスキップされている。

## 要素数の制限

### limit

指定した要素数の stream を返す。

```java
userList.stream()
        .limit(2)
        .forEach(System.out::println);
// name: John, age: 40
// name: Paul, age: 79
```

## 並べ替え

### sorted

指定したルールでソートした stream を返す。

```java
// 年齢の昇順
userList.stream()
        .sorted(Comparator.comparing(User::getAge))
        .forEach(System.out::println);
// name: John, age: 40
// name: George, age: 58
// name: Paul, age: 79
// name: Ringo, age: 81

// 年齢の降順
userList.stream()
        .sorted(Comparator.comparing(User::getAge).reversed())
        .forEach(System.out::println);
// name: Ringo, age: 81
// name: Paul, age: 79
// name: George, age: 58
// name: John, age: 40
```

## 条件判定

### anyMatch

```java
// いずれかの要素が指定した条件を満たせば true
boolean anyMatch = userList.stream()
                           .anyMatch(u -> u.getAge() < 60);
System.out.println(anyMatch);
// true
```

### allMatch

```java
// 全ての要素が指定した条件を満たせば true
boolean allMatch = userList.stream()
                           .anyMatch(u -> u.getAge() < 60);
System.out.println(allMatch);
// false
```

### noneMatch

```java
// 全ての要素が指定した条件を満たさなければ true
boolean noneMatch = userList.stream()
                           .noneMatch(u -> u.getName().equals("Pete"));
System.out.println(noneMatch);
```

## 先頭の要素を取得

### findFirst

Optional 型を返すので、orElse などが必要となる。

```java
User user = userList.stream()
                    .findFirst()
                    .orElse(null);
System.out.println(user);
```

## 集計

### max

```java
// 年齢が最大のユーザ
User maxAgeUser = userList.stream()
                          .max(Comparator.comparing(User::getAge))
                          .orElse(null);
System.out.println(maxAgeUser);
// name: Ringo, age: 81
```

### min

```java
// 年齢が最小のユーザ
User minAgeUser = userList.stream()
                          .min(Comparator.comparing(User::getAge))
                          .orElse(null);
System.out.println(minAgeUser);
// name: John, age: 40
```

### count

```java
// 要素の個数
long count = userList.stream()
                     .count();
System.out.println(count);
// 4
```

### average

```java
// 年齢の平均
double average = userList.stream()
                     .mapToInt(User::getAge)
                     .average()
                     .orElse(0);
System.out.println(average);
// 64.5
```

### sum

```java
// 年齢の合計
int sum = userList.stream()
                  .mapToInt(User::getAge)
                  .sum();
System.out.println(sum);
// 258
```

## 値をまとめる

### reduce

```java
// 全員の名前をカンマ区切りで並べた文字列を取得
String result = userList.stream()
                        .map(User::getName)
                        .reduce((res, u) -> res += ", " + u)
                        .orElse("");
System.out.println(result);
// John, Paul, George, Ringo
```

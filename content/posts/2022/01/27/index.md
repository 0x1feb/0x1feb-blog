---
title: "複数の要素を Stream でまとめる"
slug: "combining-multi-elements-in-java-stream"
date: 2022-01-27T22:28:34+09:00
draft: false
categories: ["Java"]
tags: ["Java 8"]
---

## やりたいこと

単体のリストではない複数の要素に、同じ処理を適用したい。

複数のリストや要素を一時的にまとめた Stream を作成し、一括で処理したい。

```java
public class User {
    private String name;
    private int age;

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // getter と setter は省略

    public String toString() {
        return "name: " + name + ", age: " + age;
    }
}
```

以下のリスト1とリスト2をまとめたり、リスト1と単体の要素1をまとめたりして処理する。

```java
// リスト1
List<User> userList1 = new ArrayList<User>();
userList1.add(new User("John", 40));
userList1.add(new User("Paul", 79));
userList1.add(new User("George", 58));
userList1.add(new User("Ringo", 81));

// リスト2
List<User> userList2 = new ArrayList<User>();
userList2.add(new User("Albert", 76));
userList2.add(new User("Richard", 69));

// 単体の要素1
User user1 = new User("Tanaka", 36);

// 単体の要素2
User user2 = new User("Suzuki", 74);
```

## 単体の要素同士

`Stream.of` に要素を列挙して Stream を作成する。

```java
Stream.of(user1, user2)
      .forEach(System.out::println);
// name: Tanaka, age: 36
// name: Suzuki, age: 74
```

## リスト同士

`Stream.of` でリストをまとめると、リスト単位で処理する。

```java
Stream.of(userList1, userList2)
      .forEach(System.out::println);
// [name: John, age: 40, name: Paul, age: 79, name: George, age: 58, name: Ringo, age: 81]
// [name: Albert, age: 76, name: Richard, age: 69]
```

リスト内の要素単位で処理する場合は、`flatMap` を用いる。

```java
Stream.of(userList1, userList2)
      .flatMap(Collection::stream)
      .forEach(System.out::println);
// name: John, age: 40
// name: Paul, age: 79
// name: George, age: 58
// name: Ringo, age: 81
// name: Albert, age: 76
// name: Richard, age: 69
```

各リストを Stream に変換し、均した新しい Stream を返ため、各要素単位で処理できる。

## 単体の要素とリスト

リストと単体の要素を個別に Stream に変換し、`Stream.concat` でまとめた Stream を作成する。

```java
Stream.concat(userList1.stream(), Stream.of(user1))
      .forEach(System.out::println);
// name: John, age: 40
// name: Paul, age: 79
// name: George, age: 58
// name: Ringo, age: 81
// name: Tanaka, age: 36
```

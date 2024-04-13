# sensors_plus_ohos

[![pub package](https://img.shields.io/pub/v/sensors_plus_ohos.svg)](https://pub.dartlang.org/packages/sensors_plus_ohos) [![GitHub stars](https://img.shields.io/github/stars/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/stargazers) [![GitHub forks](https://img.shields.io/github/forks/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/network) [![GitHub license](https://img.shields.io/github/license/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/harmonycandies/sensors_plus_ohos)](https://github.com/harmonycandies/sensors_plus_ohos/issues) <a target="_blank" href="https://qm.qq.com/q/ajfsyk2RcA"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="harmony-candies" title="harmony-candies"></a>

Flutter plugin for accessing accelerometer, gyroscope, and magnetometer sensors On OpenHarmony.

The OpenHarmony implementation of [`sensors_plus`][1].

[`sensors_plus`][1] 在 OpenHarmony 平台的实现。


# 使用

```yaml
dependencies:
  sensors_plus: 4.0.2
  sensors_plus_ohos: any
```

在你的项目的 `module.json5` 文件中增加以下权限设置。

```json
    requestPermissions: [
      {"name" :  "ohos.permission.ACCELEROMETER"},
      {"name" :  "ohos.permission.GYROSCOPE"},
    ],
```


 [1]: https://pub.dev/packages/sensors_plus


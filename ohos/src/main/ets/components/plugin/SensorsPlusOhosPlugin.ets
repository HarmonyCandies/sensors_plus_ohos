import {
  EventChannel,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult
} from "@ohos/flutter_ohos";
import {
  AccelerometerStreamHandlerPlus,
  GyroscopeStreamHandlerPlus,
  MagnetometerStreamHandlerPlus,
  PressureStreamHandlerPlus,
  SensorStreamHandlerImpl,
  UserAccelerometerStreamHandlerPlus
} from "./StreamHandlerPlus";

const METHOD_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/method";
const ACCELEROMETER_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/accelerometer";
const GYROSCOPE_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/gyroscope";
const USER_ACCELEROMETER_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/user_accel";
const MAGNETOMETER_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/magnetometer";
const BAROMETER_CHANNEL_NAME = "dev.fluttercommunity.plus/sensors/barometer";

export default class SensorsPlusOhosPlugin implements FlutterPlugin, MethodCallHandler {
  private methodChannel: MethodChannel | undefined
  private accelerometerChannel: EventChannel | undefined
  private userAccelerometerChannel: EventChannel | undefined
  private gyroscopeChannel: EventChannel | undefined
  private magnetometerChannel: EventChannel | undefined
  private barometerChannel: EventChannel | undefined
  private accelerometerStreamHandler: SensorStreamHandlerImpl | undefined
  private userAccelerometerStreamHandler: SensorStreamHandlerImpl | undefined
  private gyroscopeStreamHandler: SensorStreamHandlerImpl | undefined
  private magnetometerStreamHandler: SensorStreamHandlerImpl | undefined
  private barometerStreamHandler: SensorStreamHandlerImpl | undefined

  getUniqueClassName(): string {
    return "SensorsPlusOhosPlugin";
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.setupMethodCallHandler(binding);
    this.setupEventChannels(binding);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.disposeMethodChannel();
    this.disposeEventChannels();
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    let streamHandler: SensorStreamHandlerImpl | undefined;
    switch (call.method) {
      case "setAccelerationSamplingPeriod":
        streamHandler = this.accelerometerStreamHandler;
        break;
      case "setUserAccelerometerSamplingPeriod":
        streamHandler = this.userAccelerometerStreamHandler;
        break;
      case "setGyroscopeSamplingPeriod":
        streamHandler = this.gyroscopeStreamHandler;
        break;
      case "setMagnetometerSamplingPeriod":
        streamHandler = this.magnetometerStreamHandler;
        break;
      case "setBarometerSamplingPeriod":
        streamHandler = this.barometerStreamHandler;
        break;
      default:
        streamHandler = undefined;
    }

    if (streamHandler) {
      streamHandler.samplingPeriod = call.args as number;
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  setupMethodCallHandler(binding: FlutterPluginBinding): void {
    this.methodChannel = new MethodChannel(binding.getBinaryMessenger(), METHOD_CHANNEL_NAME);
    this.methodChannel.setMethodCallHandler(this);
  }

  setupEventChannels(binding: FlutterPluginBinding): void {
    this.accelerometerChannel = new EventChannel(binding.getBinaryMessenger(), ACCELEROMETER_CHANNEL_NAME);
    this.accelerometerStreamHandler = AccelerometerStreamHandlerPlus();
    this.accelerometerChannel.setStreamHandler(this.accelerometerStreamHandler);

    this.userAccelerometerChannel = new EventChannel(binding.getBinaryMessenger(), USER_ACCELEROMETER_CHANNEL_NAME);
    this.userAccelerometerStreamHandler = UserAccelerometerStreamHandlerPlus();
    this.userAccelerometerChannel.setStreamHandler(this.userAccelerometerStreamHandler);

    this.gyroscopeChannel = new EventChannel(binding.getBinaryMessenger(), GYROSCOPE_CHANNEL_NAME);
    this.gyroscopeStreamHandler = GyroscopeStreamHandlerPlus();
    this.gyroscopeChannel.setStreamHandler(this.gyroscopeStreamHandler);

    this.magnetometerChannel = new EventChannel(binding.getBinaryMessenger(), MAGNETOMETER_CHANNEL_NAME);
    this.magnetometerStreamHandler = MagnetometerStreamHandlerPlus();
    this.magnetometerChannel.setStreamHandler(this.magnetometerStreamHandler);

    this.barometerChannel = new EventChannel(binding.getBinaryMessenger(), BAROMETER_CHANNEL_NAME);
    this.barometerStreamHandler = PressureStreamHandlerPlus();
    this.barometerChannel.setStreamHandler(this.barometerStreamHandler);
  }

  disposeMethodChannel(): void {
    this.methodChannel?.setMethodCallHandler(null);
  }

  disposeEventChannels(): void {
    this.accelerometerChannel?.setStreamHandler(null);
    this.userAccelerometerChannel?.setStreamHandler(null);
    this.gyroscopeChannel?.setStreamHandler(null);
    this.magnetometerChannel?.setStreamHandler(null);
    this.barometerChannel?.setStreamHandler(null);

    this.accelerometerStreamHandler?.onCancel(null);
    this.userAccelerometerStreamHandler?.onCancel(null);
    this.gyroscopeStreamHandler?.onCancel(null);
    this.magnetometerStreamHandler?.onCancel(null);
    this.barometerStreamHandler?.onCancel(null);
  }
}
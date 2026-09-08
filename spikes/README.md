# Technology spikes

`SPIKE-V0-01` là tập con chẩn đoán của kế hoạch K3.2. Nó không thay thế workload `SPIKE-W0-01` đầy đủ.

## Cấu trúc

- `shared-spec/fixture`: đầu vào chung không phụ thuộc candidate.
- `shared-spec/expected`: trạng thái cuối làm oracle độc lập.
- `shared-spec/conditions`: trạng thái điều kiện của lượt spike.
- `s0-pwa`: core JavaScript, PWA text tối thiểu và runner Node.
- `evidence`: kết quả máy đọc được của Dart và JavaScript.

## Chạy

Từ `game/`:

```powershell
dart run tool/run_shared_spike.dart
```

Từ `spikes/s0-pwa/`:

```powershell
npm test
npm run spike
```

Hai runner phải trả cùng hash `5629ba88282991c6`. Số đo thời gian chỉ dùng chẩn đoán vì chưa phải build release tương đương.

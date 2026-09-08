---
title: "K4.4 — Địa lý, khí hậu, thủy văn, đất, sinh thái và linh sinh quyển"
aliases:
  - "Môi trường và sinh thái K4"
  - "Linh sinh quyển K4"
tags:
  - reality-cultivation
  - ke-hoach
  - k4
  - moi-truong
status: de-xuat
updated: 2026-09-06
---

# K4.4 — Địa lý, khí hậu, thủy văn, đất, sinh thái và linh sinh quyển

> [!summary]
> Tài liệu này mở rộng [[MOI_TRUONG]] trên nền [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]], [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]] và [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. Thế giới được tổ chức theo địa hình–lưu vực–khí hậu–đất–quần thể–linh trường, có lịch sử, dòng qua biên và phản hồi với cộng đồng. Đây là thiết kế chưa triển khai.

## 1. Mục tiêu

Môi trường không phải phông nền. Nó là hệ thống tự vận hành:

```text
địa chất/địa hình → khí hậu/thời tiết → nước và trầm tích
→ đất/dinh dưỡng → sinh vật/quần thể → khai thác và cư trú
→ biến đổi cảnh quan/ô nhiễm → phản hồi trở lại các dòng

linh nguồn/địa mạch → linh trường → sinh vật/vật liệu/công pháp
→ khai thác/trận pháp/đột phá → nhiễu động và lịch sử linh sinh quyển
```

Một vụ hạn, cháy rừng, săn quá mức hoặc rút cạn linh mạch phải có hậu quả về sau, kể cả khi người chơi chưa từng nhìn thấy nơi đó.

## 2. Phạm vi

K4.4 định:

- không gian địa lý phân cấp và topology;
- địa chất, địa mạo, địa hình và tài nguyên;
- khí hậu, mùa, thời tiết và vi khí hậu;
- chu trình nước mặt/ngầm, chất lượng nước và trầm tích;
- đất, chất hữu cơ, dinh dưỡng và xói mòn;
- loài, quần thể, vòng đời, niche và mạng thức ăn;
- thực vật, động vật, vi sinh và tác nhân bệnh môi trường;
- diễn thế, thiên tai và disturbance;
- linh mạch, linh trường, linh loài và dị cảnh;
- nông nghiệp, khai thác, ô nhiễm, công trình và phục hồi;
- sinh thế giới, phân giải, lưu tải, UI và kiểm chứng.

## 3. Ranh giới chủ quản

| Miền | Sở hữu |
|---|---|
| K4.1 | quantity, field, reaction, transfer và BoundaryFlow |
| K4.2 | BodyInstance, nhu cầu, bệnh và phơi nhiễm cá thể |
| K4.3 | vật khai thác, công cụ, công trình, chất thải và process chế tác |
| K4.4 | landscape, climate, water, soil, habitat, population và ecological process |
| NPC/xã hội | quyết định, tri thức, quyền, tổ chức và chính sách |
| kinh tế | giá, trao đổi, sinh kế và phân bổ nguồn |

K4.4 tạo hazard/signal/resource state; nó không tự cho NPC biết hoặc tự đặt hành vi.

## 4. Các lớp không gian

```text
World/Cosmology
  MacroRegion
    GeologicalProvince / ClimateRegion
      Watershed / Aquifer / EcologicalRegion
        LandscapeUnit
          Patch / Reach / SoilColumn
            LocalCell / HabitatFeature / Site
```

Biên địa chất, khí hậu, thủy văn, sinh thái và hành chính có thể chồng nhưng không bắt buộc trùng.

## 5. Stable spatial identity

Mỗi vùng có `spatial_id`, coordinate reference, parent/overlap relations, geometry representation, topology, generation provenance và revision. Tách/gộp vùng không đổi lịch sử của anchor.

Tên địa phương là View theo ngôn ngữ/văn hóa; không thay ID. Hai cộng đồng có thể gọi cùng núi bằng tên khác.

## 6. Geometry và topology

Hình học có thể là cell, polygon rút gọn, graph, elevation profile hoặc parametric patch. Topology giữ:

- adjacency;
- upstream/downstream;
- contains/overlaps;
- route/connectivity;
- barrier/pass;
- surface/subsurface relation;
- field boundary.

Không cần bản đồ raster toàn thế giới ở độ phân giải cao.

## 7. Độ cao, dốc và hướng sườn

Elevation surface sinh slope/aspect, drainage, exposure, shadow và khả năng di chuyển. Công trình/đào/lở có thể đổi cục bộ.

Không lưu nhãn “đồi” làm nguồn duy nhất; nhãn cảnh quan suy từ geometry và văn hóa.

## 8. Địa chất

`GeologicalUnit` có age/order, lithology/material composition, structure, porosity/permeability, fractures, deposits và spiritual coupling. Lịch sử kiến tạo/biến chất có thể được tóm lược thành provenance và state.

Địa chất quyết định nền tài nguyên, nước ngầm, đất và linh mạch; không phải bảng loot độc lập.

## 9. Địa mạo

Erosion, deposition, uplift/subsidence, weathering và mass movement tạo landform theo thời gian. Chặng chơi có thể giải chậm bằng breakpoint/epoch, còn lũ/lở giải chi tiết.

Đường sông, bờ và sườn có thể đổi; route/công trình phải nhận invalidation.

## 10. Mỏ và deposit

Deposit là volume/vein/layer có composition distribution, grade, geometry, accessibility, water/gas/hazard và ownership/knowledge tách biệt.

Khai thác chuyển parcel, tạo void/tailings/dust/water change. Mỏ không hồi đầy nếu không có process/LawRef.

## 11. Hang động và không gian ngầm

Subsurface graph có chambers, passages, rock support, air/water, organisms, deposits và spiritual fields. Sập hoặc đào mở edge mới.

Thông khí, ngập và mất đường xảy ra theo topology. Hang chưa khám phá tồn tại theo seed/constraints, không sinh theo nhu cầu loot.

## 12. Khí hậu nền

ClimateDefinition mô tả phân bố dài hạn của nhiệt, mưa, ẩm, gió, bức xạ và extreme regime theo vị trí/độ cao/mùa. Nó là điều kiện nền, không là thời tiết từng ngày.

Thông số khí hậu thế giới hư cấu chưa chốt; phải giữ coherence không gian và mùa.

## 13. Mùa và lịch thiên văn

Mùa phát sinh từ orbital/cosmological cycle hoặc LawRef, ảnh hưởng forcing, daylight và pattern. Lịch văn hóa ánh xạ lên chu kỳ nhưng không điều khiển khí hậu.

Nếu thế giới có nhiều mặt trời/trăng hoặc chu kỳ linh triều, generator phải khai period/phase/coupling.

## 14. WeatherState

State vùng gồm nhiệt, áp, ẩm, cloud/water content, wind, precipitation potential và spiritual perturbation nếu có. WeatherProcess truyền/biến đổi qua BoundaryFlow.

Không cần mô hình khí tượng đầy đủ; cần continuity, budget nước/năng lượng và correlation giữa vùng.

## 15. Sinh thời tiết có kiểm soát

Weather realization dùng seed theo lineage/vùng/time và state trước đó. Khi chưa ảnh hưởng gì, có thể sinh lười. Khi tạo mưa, gió, sét, observation hoặc quyết định, event/state trở thành canonical.

Tải lại không đổi trận mưa đã làm ướt ruộng hoặc trì hoãn đoàn hàng.

## 16. Front và storm object

Biến cố rộng dùng ProcessInstance có path, extent, intensity, speed, lifetime, rainfall/wind/temperature fields và uncertainty dự báo. Nó đi qua nhiều shard bằng flow/event id.

Hai vùng không sinh hai nửa cơn bão mâu thuẫn; chủ quản macro phát boundary contract.

## 17. Gió

Wind field có direction/speed/gust theo layer/resolution, bị địa hình/canopy/công trình đổi cục bộ. Gió vận chuyển nhiệt, ẩm, khói, hạt, âm và sinh vật nhỏ.

Một nhãn “gió mạnh” là View; tác động phụ thuộc hình học và exposure thật.

## 18. Mưa, tuyết và kết tủa linh

Precipitation có phase, rate, drop/particle properties, composition và duration. Nó đi vào canopy, surface, snowpack, soil hoặc water body.

Mưa linh hoặc bụi linh cần Matter/SpiritualQuantity, nguồn và coupling; không tự buff toàn vùng.

## 19. Vi khí hậu

Canopy, water, slope, aspect, soil, building, fire và linh field tạo microclimate. Patch gần nhau có nhiệt/ẩm/gió khác.

Ở resolution thấp giữ deviations/hotspots quan trọng; không lấy climate average cho hang kín hoặc ruộng có tưới.

## 20. Dự báo và tri thức thời tiết

NPC quan sát mây, gió, động vật, dụng cụ hoặc thuật để suy đoán. Forecast là Belief distribution có horizon/confidence, không đọc future seed.

Kiến thức địa phương có thể tốt hơn mô hình thô nhưng vẫn sai; kết quả không bị engine sửa cho khớp dự báo.

## 21. Chu trình nước

```text
khí quyển → kết tủa → interception/snow
→ infiltration/runoff → soil/groundwater/river/lake
→ uptake/use → evapotranspiration/discharge
→ khí quyển/biển/ngoại biên
```

Mỗi kho có lượng/chất lượng; mỗi cạnh có rate/capacity và provenance.

## 22. Interception và bốc hơi

Canopy/vật/công trình giữ một phần nước, sau đó nhỏ, chảy thân hoặc bay hơi. Evaporation phụ thuộc surface, nhiệt, ẩm, gió và energy.

Không cho toàn bộ mưa vào đất hoặc sông tức thì.

## 23. Infiltration và đất ẩm

Soil column có layers, porosity, saturation, permeability và preferential paths. Infiltration cạnh tranh runoff; compaction/crust/vegetation đổi rate.

Nước đất không là một phần trăm duy nhất nếu rễ và dòng cục bộ quan trọng.

## 24. Runoff

Runoff phát sinh khi input vượt infiltration/storage hoặc đất bão hòa. Flow theo slope/roughness/path, mang sediment/contaminant.

Đường, ruộng và nhà đổi drainage; nước không biến mất tại biên site.

## 25. Sông và stream network

Reach graph có upstream, downstream, storage, discharge, cross-section, bed material, bank integrity, temperature và quality. Flow routing dùng travel time và attenuation.

Rút nước/đập/chặn tạo thay đổi downstream sau độ trễ, không lập tức toàn lưu vực.

## 26. Hồ, ao và vùng ngập

Water body có bathymetry rút gọn, volume–level relation, inflow/outflow, stratification nếu cần, sediment và ecology. Mực nước đổi diện tích habitat.

Ao nhỏ có thể cạn, đóng băng, phú dưỡng hoặc ô nhiễm theo ledger.

## 27. Nước ngầm

Aquifer graph/field có storage, head, permeability, recharge, discharge và contamination plume. Giếng là interface extraction.

Hút quá mức hạ head và ảnh hưởng suối/giếng khác theo topology; không phải mỗi giếng có kho nước riêng vô hạn.

## 28. Tuyết, băng và tan

Snowpack giữ water equivalent, density, temperature, impurities và layers. Melt/refreeze phụ thuộc energy; avalanche/glacier chỉ materialize nơi cần.

Nước tan tạo pulse có thời gian và có thể gây lũ/xói mòn.

## 29. Chất lượng nước

Composition gồm sediment, salts/nutrients, organic matter, pathogens, toxins, temperature và spiritual content. Potability là capability/assessment theo loài và treatment.

“Nước sạch” là View; đun/lọc/thuật xử lý chuyển đúng thành phần và tạo waste.

## 30. Trầm tích

Erosion tạo sediment theo size/composition; flow vận chuyển và lắng theo capacity. Sediment đổi lòng sông, độ đục, đất bồi và habitat.

Không xóa đất ở sườn rồi sinh đất mới ở ruộng mà thiếu transfer.

## 31. FloodProcess

Lũ có hydrograph, extent, depth/velocity, sediment/contaminant và duration. Nó ảnh hưởng người, vật, công trình, đất và quần thể theo location/exposure.

Vùng xa giữ peak/extents/anchors, không chỉ daily average che ngập cực trị.

## 32. Đất như profile

`SoilProfile` có horizons/layers với texture, structure, bulk density, porosity, organic matter, moisture, chemistry, biota và spiritual coupling.

Đất không là một “độ màu mỡ” duy nhất. Rễ, nước và công cụ tương tác theo depth/layer.

## 33. Hình thành đất

Weathering, deposition, organic input, mixing, leaching và erosion đổi profile chậm. Parent material, climate, terrain, organisms và use history là nguồn.

Generator tạo tuổi/trạng thái hợp với lịch sử, không phủ biome label lên mọi patch giống nhau.

## 34. Cấu trúc và nén đất

Aggregate/pore structure ảnh hưởng infiltration, aeration, root penetration và erosion. Đi lại, gia súc, xe và canh tác tạo compaction theo tải/ẩm.

Xới có thể giảm nén cục bộ nhưng tăng erosion/organic loss; không cộng fertility miễn phí.

## 35. Dinh dưỡng

Nutrient pools có mineral/organic/biomass forms, availability và transfer. Uptake, decomposition, fixation, leaching, harvest và amendment làm đổi pool.

Không cần mô phỏng mọi nguyên tố ngay; schema cho phép mở rộng và chặng đầu chọn nhóm giới hạn.

## 36. Chất hữu cơ và phân hủy

Detritus/litter/carcass có composition, size, accessibility và decay process. Decomposer cohorts chuyển vật chất, sinh nhiệt/khí/chất hòa tan.

Thi thể K4.2 và waste K4.3 đi vào cycle thật, không despawn.

## 37. pH, muối và độc chất đất

Chemical state ảnh hưởng availability, organisms và material processes. Irrigation, mining, ash, waste hoặc linh biến đổi có thể đổi state.

Khắc phục cần transfer/reaction/thời gian; không đặt fertility về chuẩn bằng một action.

## 38. Xói mòn đất

Rain, runoff, wind, slope, cover, root và disturbance tạo detachment/transport/deposition. Topsoil loss giảm profile thật và chuyển sediment đi.

Terrace, vegetation và structure đổi flow/capability theo tình trạng bảo trì.

## 39. Habitat

Habitat là tập điều kiện và cấu trúc không gian: nguồn, shelter, substrate, climate, disturbance, competitors/predators và linh field. Một patch có thể phục vụ nhiều life stages khác nhau.

Biome label chỉ là View/aggregation; population resolver dùng habitat variables.

## 40. SpeciesDefinition

Mỗi loài có:

- body/life-form blueprint;
- resource needs;
- environmental tolerances;
- life stages/phenology;
- reproduction/mortality;
- movement/dispersal;
- feeding/interaction traits;
- disease/parasite interfaces;
- spiritual traits;
- observation signatures.

Không cần mọi cá thể xa là Person.

## 41. PopulationState

Population cohort theo species, region/patch, stage/sex nếu cần, count/biomass, condition distribution, genetic/trait distribution và history anchors.

Cá thể hóa khi có ownership, quan sát, thương tích, tên/quan hệ hoặc gameplay; cá thể đã materialize không gộp lại làm mất identity.

## 42. Sinh trưởng và sức chứa

Growth phụ thuộc intake, temperature, water, disease, crowding và spiritual conditions. Carrying capacity là outcome động từ resource/habitat, không hằng số cố định.

Quần thể có lag và age structure; không về equilibrium ngay sau thay đổi.

## 43. Sinh sản

Reproduction có season/readiness, mate/pollination nếu cần, resource cost, fecundity và offspring survival. Cohort solver giữ births và lineage statistics; cá thể quan trọng dùng lifecycle riêng.

Không nhân đôi population bằng rate nếu thiếu parent/resource/habitat theo model.

## 44. Tử vong

Mortality causes gồm tuổi, đói, thời tiết, predation, disease, harvest và disturbance. Outcome tạo carcass/nutrient/pathogen flows và population change.

Không xóa số lượng khỏi ledger mà thiếu cause/output khi chúng có ảnh hưởng.

## 45. Di chuyển và phân tán

Movement theo route/habitat gradient, barriers, season, memory và risk. Population flow qua vùng có id/interval; cá thể có position/path.

Biên shard áp flow đúng một lần. Đường mới hoặc rào đổi connectivity từ mốc hoàn thành.

## 46. Thực vật

Plant cohort/individual có roots, stem/canopy, biomass pools, water/nutrient uptake, photosynthetic/linh coupling, phenology và reproduction.

Chặt chỉ lấy phần vật chất thật; gốc/hạt/cành còn có thể sống theo loài/state.

## 47. Rễ và cạnh tranh dưới đất

Root distribution theo depth/patch nối SoilProfile. Cây tranh water/nutrients và có thể cộng sinh. Damage/nén/khô đổi uptake.

Không chia đều tài nguyên cho mọi cây nếu access khác nhau.

## 48. Tán cây và ánh sáng

Canopy layers chặn/tán ánh sáng, mưa, gió và tạo vi khí hậu. Leaf area/coverage có thể aggregate.

Chặt tán đổi ánh sáng/nước/nhiệt từ đúng mốc, ảnh hưởng cây dưới và đất.

## 49. Phenology

Nảy mầm, ra lá, hoa, quả, rụng và ngủ phụ thuộc tích lũy nhiệt/ánh sáng/nước/signal/linh. Không bật theo ngày lịch cố định cho mọi vùng.

Thời tiết lệch mùa tạo outcome lịch sử thật.

## 50. Động vật

Animal cohort/individual có body need, foraging, shelter, territory, migration, reproduction, learning và sociality theo loài. Person-level chỉ cho cá thể cần identity/agency sâu.

Săn bắt tương tác với cá thể/cohort qua encounter và observation, không rút thẳng “1 thịt” từ biome.

## 51. Foraging

Consumer tìm resource theo knowledge/sensory range, travel cost, risk và competition. Consumption chuyển biomass/nutrient thật.

NPC/động vật không biết resource chưa phát hiện; vùng xa dùng allocation theo accessibility.

## 52. Predation

Predator–prey encounter phụ thuộc overlap, detection, pursuit, group, body và environment. Cohort model dùng encounter rates nhưng giữ carcass/major outcome anchors.

Không trừ prey rồi cộng predator energy bằng hai phép độc lập không khớp.

## 53. Cạnh tranh

Loài/cá thể cạnh tranh khi dùng chung resource/habitat hạn chế. Outcome phụ thuộc access, timing và traits, không chỉ hệ số sức mạnh.

Competition có thể gián tiếp qua depletion hoặc habitat modification.

## 54. Cộng sinh và hỗ trợ

Mutualism, commensalism và facilitation là exchange/service links có điều kiện. Mất một bên đổi process của bên kia với độ trễ.

Không gắn buff vĩnh viễn nếu interaction/resource đã mất.

## 55. Ký sinh và bệnh sinh thái

Parasite/pathogen có reservoir, host range, vector/environment stage và transmission. K4.4 quản prevalence/flow; K4.2 quản infection cá thể.

Dịch có thể lan qua nước, vật, người và động vật; source attribution dựa trên trace, không toàn tri.

## 56. Mạng thức ăn

Food web là graph các resource/consumer/decomposer interactions với biomass/energy transfer. Omnivory và stage-specific diet được phép.

Không ép chuỗi tuyến tính; thay một loài có thể tạo cascade qua nhiều cạnh và độ trễ.

## 57. Niche và thích nghi

Niche là tập requirement/tolerance/interaction, không một nhãn. Trait distribution trong population đổi survival/reproduction theo environment.

Evolution dài hạn có thể dùng aggregate selection/mutation, nhưng không tự viết lại SpeciesDefinition của cá thể cũ thiếu lineage/version.

## 58. Diễn thế

Sau disturbance, colonization, growth, competition và soil change tạo succession. State phụ thuộc seed bank, survivors, connectivity và climate.

Rừng không hồi ngay theo timer; có thể sang trạng thái khác nếu feedback thay đổi.

## 59. Stability và regime shift

Ecosystem có feedback, reserve và thresholds. Vượt ngưỡng có thể chuyển regime như hồ trong→đục, rừng→cỏ hoặc linh địa ổn→nhiễu.

Threshold không bắt buộc người chơi biết; signals và history cho phép suy luận.

## 60. Fire ecology

Fire dùng nhiên liệu, độ ẩm, gió, địa hình và ignition từ K4.1. K4.4 cung cấp fuel layers, spread topology, mortality, ash/nutrient và recovery.

Vùng xa giữ perimeter/peak/hotspot/major losses; không chỉ giảm “độ rừng”.

## 61. Hạn

Drought là deficit tích lũy ở precipitation, soil moisture, groundwater và storage so với demand. Nó có onset chậm, spatial extent và recovery lag.

Mưa một ngày không tự xóa toàn bộ drought nếu aquifer/soil/ecology chưa hồi.

## 62. Bão, rét và nắng nóng

Extreme event tạo exposure theo time/location, ảnh hưởng cơ thể, cây, vật, công trình và quần thể. Damage không áp đồng đều toàn region.

Shelter, slope, canopy, water và preparation đổi outcome thật.

## 63. Lở đất và sập

Slope stability phụ thuộc material, water, geometry, roots, excavation và load. Failure tạo debris parcels, terrain/topology change và hazard.

Không dùng event chỉ chặn đường; vật liệu và dòng nước sau đó tiếp tục tồn tại.

## 64. Disturbance ledger

Mỗi biến cố giữ footprint, intensity, duration, causes, transfers, survivors, structural changes và recovery state. Disturbance chồng lấp, không reset succession.

Anchor events được giữ khi hạ resolution.

## 65. Linh mạch

Linh mạch là geological/spiritual network có source, reservoir, conductance, affinity, stability và coupling với nước/đá/sinh vật. Nó có topology và lịch sử.

Rút, chặn, trận pháp hoặc địa biến đổi flow downstream; không là node mana riêng cho từng địa điểm.

## 66. Linh trường cảnh quan

Field tạo gradient, hotspot, seasonal tide, interference và anomaly. Terrain/material/organism/formation là nguồn hoặc boundary.

“Linh địa cấp ba” là View/standard; state thật là field và resources có thể đổi.

## 67. Linh sinh vật

Loài có thể hấp thu, lưu, biến đổi hoặc phát linh quantity qua cấu trúc K4.2. Ecological role bao gồm competition/predation/mutualism linh.

Linh thú không chỉ là động vật cộng cấp; nhu cầu, vòng đời và ảnh hưởng môi trường phải khác có cơ chế.

## 68. Linh thực vật và linh dược

Potency phát sinh từ genotype/lineage, tuổi/stage, soil/water/climate, linh field, stress, harvest part/time và post-harvest process.

Một cây cùng loài không cho vật phẩm giống hệt. Thu hoạch quá mức đổi population và seed bank.

## 69. Dị cảnh và vùng quy luật khác

AnomalyRegion có LawRef overlay, boundary, stability, source và interaction policy. Vào/ra chuyển field/matter theo contract.

Không dùng dị cảnh để bỏ mọi invariant; những luật khác phải khai rõ phạm vi và hậu quả biên.

## 70. Linh triều và biến cố linh

Spiritual cycle/event có phase, extent, quantities, coupling và forecast signals. Nó có thể ảnh hưởng công pháp, sinh vật, vật liệu và thời tiết.

Một biến cố đã tác động trở thành canonical, không reroll theo lần vào vùng.

## 71. Ô nhiễm linh

Unstable/corrupted spiritual composition truyền qua field, carrier, organism hoặc artifact. “Ô nhiễm” là classification theo effect/standard, không quantity tự do.

Thanh tẩy chuyển/biến đổi nó theo LawRef và tạo residue/cost; không xóa miễn phí.

## 72. Nông nghiệp

Crop system nối seed/genotype, soil, water, weather, pests, labor, tools, nutrients và harvest. Field có patch history, rotation và ownership.

Yield là outcome biomass allocation và losses, không roll độc lập cuối mùa.

## 73. Tưới và thoát nước

Canal/ditch/gate/pump là structures/networks K4.3 nối hydrology. Quyền lấy nước, lịch vận hành và maintenance thuộc xã hội.

Tưới upstream làm đổi downstream; rò/thấm có thể nạp groundwater hoặc gây úng.

## 74. Chăn nuôi

Đàn có Person/animal individuals hoặc cohorts, feed/water, shelter, disease, breeding, labor và waste. Vật nuôi quan trọng giữ identity.

Không chuyển cỏ thành thịt trực tiếp; body growth/reproduction và mortality có thời gian.

## 75. Lâm nghiệp và hái lượm

Harvest plan chọn loài, part, kích thước, mùa, intensity và access. Output là parcel K4.3; patch mất biomass/structure và bước vào recovery.

Hái “bền vững” phải so regeneration/recruitment thực, không là tag.

## 76. Săn bắt và đánh cá

Effort, gear, knowledge, season, population và regulation quyết định encounter/catch. Catch lấy cá thể/biomass thật, có bycatch và carcass processing.

Quần thể phản ứng theo age/stage distribution và migration.

## 77. Khai khoáng và xây dựng

Extraction/earthwork đổi deposit, terrain, drainage, dust, water quality, habitat và linh network. Công trình K4.3 chiếm chỗ và tạo surface/flow boundaries.

Không cho xây đường/đập chỉ đổi movement cost mà bỏ tác động môi trường.

## 78. Chất thải

Waste parcel/flow có composition, volume, hazard và owner/cause. Dumping, treatment, burning, reuse hoặc burial là process.

Vùng xa vẫn truyền plume/odor/pathogen theo nước/khí/đất.

## 79. Ô nhiễm và plume

Contaminant source → transport → transformation → exposure → ecological/body effects. Plume giữ mass, support, concentration moments và hotspots theo resolution.

Không áp debuff đều toàn vùng hoặc xóa khi source dừng; tồn lưu/decay có thời gian.

## 80. Suy kiệt tài nguyên

Stock giảm, grade/accessibility đổi và cost tăng theo extraction. Renewable resource có regeneration phụ thuộc habitat; không phải timer cố định.

Scarcity đi vào belief/market qua observation và reports, không broadcast toàn thế giới.

## 81. Phục hồi môi trường

RestorationPlan có target state/range, interventions, resources, time, uncertainty và monitoring. Outcome phụ thuộc process và external drivers.

Trồng cây không lập tức phục hồi soil, food web hoặc linh field; có thể thất bại hoặc chuyển regime khác.

## 82. Quyền và quản trị tài nguyên

Land/water/forest/mine use có claim, commons, permit, obligation và enforcement. Quyền không tạo vật lý: người không có quyền vẫn có thể lấy nếu làm được và chịu hậu quả xã hội.

Boundary hành chính không tự chặn nước, thú hoặc ô nhiễm.

## 83. Sinh kế và phản hồi xã hội

Môi trường cung cấp resource opportunities/hazards; NPC quyết định theo tri thức, nhu cầu và luật. Harvest, migration, giá và xung đột phản hồi vào population/landscape.

Không có yield đảm bảo để giữ làng sống; thất bại phải có nguyên nhân và phương án thích nghi.

## 84. Hạ tầng và bảo trì

Đường, cầu, đê, kênh, giếng, ruộng bậc thang và trận pháp môi trường có condition/maintenance. Hỏng làm đổi route/flow/hazard.

NPC xa phải dành lao động/vật tư thật để duy trì, không tự hoạt động vì là “công trình”.

## 85. Khám phá và bản đồ

World truth tách MapKnowledge. Khảo sát tạo observations về terrain, route, water, species, deposit và linh field với accuracy/date/source.

Bản đồ có thể cũ/sai; mở bản đồ không materialize resource thuận lợi hoặc tiết lộ hidden state.

## 86. Tên đất và ý nghĩa văn hóa

PlaceName gắn language/community/time và referent belief. Một nơi có nhiều tên, tên đổi theo lịch sử, hoặc tên chỉ sai vị trí.

Thánh địa/cấm địa là quan hệ văn hóa/pháp lý cộng với state môi trường, không modifier toàn cục tự động.

## 87. World generation pipeline

```text
cosmology/boundary
→ geology/elevation
→ climate forcing
→ drainage/aquifer/water bodies
→ soil/sediment
→ habitats/species pools
→ populations/food web
→ spiritual network/anomalies
→ disturbance/prehistory
→ settlement/use history
→ current state validation
```

Các bước có vòng phản hồi nhưng publish chỉ sau khi invariant đạt.

## 88. Prehistory và equilibrium

Generator chạy epoch dài bằng aggregate, giữ mass/resource/population bounds và anchor disturbances. Không cần thế giới cân bằng tuyệt đối; current state có thể đang chuyển tiếp.

Làng, ruộng, rừng thứ sinh và mỏ đã khai phải có lịch sử giải thích state hiện tại.

## 89. Materialization order

Sinh vùng A trước/sau B cho cùng kết quả nếu không có flow mới. Shared watershed, storm, migration, trade và spiritual network đi qua boundary ledger.

Query/camera/device speed không được ảnh hưởng seed hoặc content.

## 90. Ecological resolution ER0–ER5

| Mức | Biểu diễn |
|---|---|
| ER0 | local cells/individual interactions |
| ER1 | patch/reach/soil profile và cohorts chi tiết |
| ER2 | landscape flows và population stages |
| ER3 | watershed/ecoregion balance |
| ER4 | macro-region seasonal/annual trajectories |
| ER5 | world epoch envelopes và latent constraints |

ER tách M, R, P, B và IR. Cá thể đã có identity không bị gộp mất.

## 91. Nâng và hạ ER

Hạ ER giữ total, gradients cần thiết, extrema/hotspots, unique species/items/Persons, active disasters, critical structures, population exceptions, boundary debt, history anchors và error bounds.

Nâng ER dùng seed + aggregate moments + flows + anchors. Không đặt tài nguyên, thú hay linh dược theo mục tiêu người chơi.

## 92. Aggregate sinh thái

Tùy process giữ count/biomass, stage distribution, trait moments, spatial occupancy, resource stocks, fluxes, min/max, hotspots và correlations.

Một average không được che cháy, ổ dịch, đàn thú hiếm hoặc nguồn nước độc.

## 93. BoundaryFlow môi trường

Nước, khí, nhiệt, sediment, nutrient, contaminant, organism, seed, disease và linh quantity qua biên có flow id, interval, source/destination, composition và reconciliation.

Chủ quản upstream/outflow commit một lần; retry/load không nhân flow.

## 94. Scheduler

Wakeup ở:

- weather/front arrival;
- flood/fire/storm threshold;
- reservoir/soil threshold;
- phenology/reproduction/migration;
- outbreak/regime shift;
- harvest/intervention;
- boundary flow arrival;
- ER promotion;
- observation cần state.

Không tick từng cây/giọt nước mỗi giây.

## 95. Lưu, tải và replay

Save giữ spatial/geology versions, climate/weather canonical events, storages/flows, soil profiles, habitats/populations, individual anchors, disturbance processes, spiritual networks, human modifications, ER/error debt, RNG cursors và provenance.

Derived biome labels, map tiles và caches dựng lại. Save giữa bão/lũ/cháy không chạy event hai lần.

## 96. Hiệu năng điện thoại và máy tính

Core semantic giống nhau; dùng:

- hierarchical spatial partition;
- sparse fields/hotspots;
- event/breakpoint;
- cohort/flow batch;
- seasonal solver xa;
- precomputed adjacency/catchment;
- active disaster pinning;
- bounded error debt;
- lazy materialization/index.

Máy chậm được giảm View, cache hoặc wall-clock pace; không bỏ hạn, dịch hay NPC.

## 97. UI text và bản đồ

Các tầng:

- thời tiết/hazard gần;
- địa điểm và đường đi theo hiểu biết;
- nước/đất/tài nguyên đã khảo sát;
- quần thể/dấu vết/mùa;
- lịch sử biến đổi;
- linh trường cảm nhận được;
- nguồn và độ chắc chắn;
- debug truth riêng.

Điện thoại dùng danh sách vùng/thẻ tuyến; desktop thêm bảng/bản đồ chữ. Logic thông tin giống nhau.

## 98. Artifact cần có

- Spatial/Topology/Geometry definitions;
- Geology/Deposit/Landform;
- Climate/Season/Weather/Event;
- Watershed/Reach/Aquifer/WaterBody;
- SoilProfile/NutrientCycle;
- Species/Habitat/Population/FoodWeb;
- Disturbance/Succession/Regime;
- SpiritualNetwork/Anomaly;
- LandUse/Pollution/Restoration;
- ER model, generator, fixture và oracle.

Mọi artifact có version, SourceRef, validity và migration.

## 99. Bất biến

1. Nước/vật chất/dinh dưỡng/linh lượng khớp storage–flow–source/sink.
2. Spatial topology không có cạnh mồ côi sai hợp đồng.
3. Upstream/downstream flow áp đúng một lần.
4. Weather đã ảnh hưởng là canonical.
5. Soil loss/deposition giữ sediment ledger.
6. Population birth/death/migration/harvest khớp count/biomass.
7. Cá thể có identity không gộp mất.
8. Disturbance/hotspot không bị average xóa.
9. Observation/map không lộ world truth ngoài sensor.
10. Resource extraction tạo output và landscape delta.
11. Hạ/nâng ER giữ anchors/error bound.
12. Save/load giữ process/RNG/flow exactly-once.
13. Linh anomaly có LawRef/coupling.
14. Mobile/desktop giữ semantic fingerprint.

## 100. Exploit và lỗi phải chống

- tải lại để đổi thời tiết;
- vào vùng để sinh linh dược cần thiết;
- ra khỏi vùng để cháy/dịch biến mất;
- rút nước từ hai shard cùng lúc;
- đào mỏ nhưng deposit không giảm;
- harvest không giảm quần thể/biomass;
- mưa tạo nước không qua budget;
- gộp patch xóa plume/hotspot;
- đổi ER hồi sinh loài/cá thể;
- xử lý ô nhiễm xóa vật chất;
- đập chặn nước nhưng downstream không đổi;
- chặt rừng không đổi soil/water/habitat;
- trận pháp tạo linh lượng vô hạn;
- bản đồ toàn tri cập nhật tức thì.

## 101. Fixture K4.4 đề xuất

| Fixture | Nội dung | Mục tiêu |
|---|---|---|
| K4E-F01 | lưu vực ba patch và một reach | water balance/topology |
| K4E-F02 | trận mưa trên đất khô/bão hòa | infiltration/runoff |
| K4E-F03 | hồ có inflow/outflow/evaporation | storage balance |
| K4E-F04 | giếng nối aquifer–suối | groundwater coupling |
| K4E-F05 | sườn trọc bị mưa | erosion/sediment |
| K4E-F06 | ruộng ba horizon | soil/root/nutrient |
| K4E-F07 | cây–cỏ–thú ăn cỏ–thú săn | food web/population |
| K4E-F08 | vết thương–nước–pathogen | ecology–body disease |
| K4E-F09 | cháy rừng có gió | disturbance/hotspot |
| K4E-F10 | hạn hai mùa | storage/lag/regime |
| K4E-F11 | mỏ và tailings | extraction/pollution |
| K4E-F12 | kênh tưới chia nước | structure/right/flow |
| K4E-F13 | linh mạch qua ba vùng | spiritual boundary flow |
| K4E-F14 | linh dược khác patch | potency/history |
| K4E-F15 | cùng cảnh ở ER0–ER4 | parity/error bound |
| K4E-F16 | save giữa lũ/cháy | exactly-once/replay |

Chưa fixture nào được mã hóa hoặc chạy.

## 102. Điều kiện MT01–MT96

### 102.1. Không gian, địa chất và tài nguyên

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT01 | hai vùng chia biên sông | topology/boundary id thống nhất |
| MT02 | đổi tên địa phương | spatial identity không đổi |
| MT03 | tách landscape patch | anchors/history giữ |
| MT04 | đào deposit | stock giảm, parcel/waste tăng |
| MT05 | đào mở hang | topology/air/water cập nhật |
| MT06 | lở sườn | terrain, debris và route đổi |
| MT07 | tài nguyên chưa khảo sát | không lộ qua UI |
| MT08 | materialize vùng cùng seed | geology/deposit ổn định |

### 102.2. Khí hậu và thời tiết

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT09 | cùng climate khác ngày | weather có correlation nhưng không đồng nhất |
| MT10 | mưa đã làm ướt ruộng rồi tải | trận mưa không reroll |
| MT11 | storm qua hai shard | một process/path liên tục |
| MT12 | gió gặp núi/công trình | local field đổi theo boundary |
| MT13 | hang và ngoài trời | microclimate không bị average |
| MT14 | forecast sai | Belief sai, weather truth giữ |
| MT15 | linh triều theo chu kỳ | phase/field canonical theo LawRef |
| MT16 | đổi tốc độ máy | weather outcome semantic không đổi |

### 102.3. Nước và trầm tích

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT17 | mưa trên canopy | interception/evaporation/runoff balance |
| MT18 | đất khô so bão hòa | infiltration/runoff khác hợp lý |
| MT19 | rút nước upstream | downstream đổi sau travel time |
| MT20 | hồ bốc hơi | volume giảm, water không biến mất khỏi system boundary |
| MT21 | hút giếng | aquifer head và suối liên quan đổi |
| MT22 | tuyết tan nhanh | pulse flow/lũ có mốc |
| MT23 | pollutant vào sông | plume bảo toàn và truyền downstream |
| MT24 | xói sườn | soil loss bằng sediment output/deposition |

### 102.4. Đất và chu trình chất

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT25 | rễ chỉ ở tầng nông | không dùng nước tầng sâu miễn phí |
| MT26 | đất bị nén khi ướt | structure/infiltration đổi theo tải |
| MT27 | thu hoạch crop | nutrient/biomass rời patch thật |
| MT28 | bón chất | parcel chuyển vào pool, không cộng fertility chung |
| MT29 | xác phân hủy | matter sang decomposer/soil/gas theo process |
| MT30 | mưa rửa nutrient | leaching flow có đích |
| MT31 | phủ cây giảm xói | đổi cover/root/flow theo thời gian |
| MT32 | phục hồi đất | không reset profile tức thì |

### 102.5. Quần thể và vòng đời

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT33 | birth cohort | parent/resource/lifecycle ledger khớp |
| MT34 | mortality | count giảm và carcass/output tồn tại |
| MT35 | migration qua vùng | outflow/inflow áp đúng một lần |
| MT36 | cá thể được đặt tên | không gộp mất identity |
| MT37 | sức chứa giảm | population phản ứng có lag |
| MT38 | harvest chọn cá thể lớn | stage distribution đổi đúng |
| MT39 | cùng loài khác habitat | growth/survival có thể khác |
| MT40 | species evolve aggregate | lineage/version không viết lại cá thể cũ |

### 102.6. Mạng sinh thái

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT41 | consumer ăn resource | biomass/energy transfer khớp |
| MT42 | predator không gặp prey | không trừ population từ xa vô cớ |
| MT43 | hai loài tranh nước | allocation theo access/timing |
| MT44 | mất loài cộng sinh | service/buff mất theo interaction |
| MT45 | pathogen qua vector | transmission chain có source |
| MT46 | bỏ predator | cascade có độ trễ qua food web |
| MT47 | disturbance rồi succession | phụ thuộc survivor/seed/connectivity |
| MT48 | vượt regime threshold | state chuyển có trace, không timer tùy ý |

### 102.7. Thiên tai và cực trị

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT49 | cháy theo gió/nhiên liệu | perimeter và losses theo state |
| MT50 | hạ ER giữa cháy | hotspot/anchor không mất |
| MT51 | lũ peak ngắn | không bị daily average che |
| MT52 | hạn rồi mưa một ngày | storage/ecology chưa tự hồi hết |
| MT53 | bão qua làng | exposure theo vị trí/shelter |
| MT54 | lở chặn sông | topology và nguy cơ hồ tạm cập nhật |
| MT55 | hai disturbance chồng | lịch sử/state không reset |
| MT56 | save giữa thiên tai | process tiếp tục đúng mốc/RNG |

### 102.8. Linh sinh quyển

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT57 | rút linh từ upstream | field/reservoir downstream đổi |
| MT58 | trận pháp chặn linh mạch | topology/flow có cause |
| MT59 | linh thú ăn linh thực | spiritual/matter ledger khớp |
| MT60 | linh dược cùng loài khác patch | potency theo environment/history |
| MT61 | thu hoạch quá mức | population/seed bank giảm |
| MT62 | anomaly có LawRef | ngoại lệ chỉ trong boundary |
| MT63 | ô nhiễm linh | carrier/field/exposure có trace |
| MT64 | thanh tẩy | quantity chuyển/biến đổi, có cost/residue |

### 102.9. Cộng đồng và khai thác

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT65 | tưới upstream | downstream/right conflict phát sinh từ flow |
| MT66 | kênh không bảo trì | condition/leak/capacity đổi |
| MT67 | chặt rừng | biomass, habitat, water/soil đổi |
| MT68 | săn quá mức | stage/population và sinh kế đổi |
| MT69 | mine tailings | waste/plume/hazard tồn tại |
| MT70 | xây đường | connectivity và runoff/habitat đổi |
| MT71 | NPC không biết hạn sắp tới | quyết định theo forecast/stock họ biết |
| MT72 | xả trái phép | vật lý xảy ra, quyền/hậu quả xã hội tách |

### 102.10. Tri thức và UI

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT73 | bản đồ cũ | route/resource belief có thể sai |
| MT74 | hai cộng đồng gọi một núi khác | same spatial id, display khác |
| MT75 | NPC thấy nước đục | Observation không tự biết chất độc cụ thể |
| MT76 | khảo sát linh mạch | kết quả theo sensor/skill/uncertainty |
| MT77 | query tìm linh dược | không sinh vật theo nhu cầu |
| MT78 | mở bản đồ nhiều lần | world/RNG không đổi |
| MT79 | tin cháy truyền chậm | NPC xa chưa biết trước message |
| MT80 | mobile/desktop View | cùng knowledge, semantic content giống |

### 102.11. Phân giải và boundary

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT81 | ER0 so ER3 cùng lưu vực | totals/outcome trong error contract |
| MT82 | hạ ER có loài hiếm | exception/identity giữ |
| MT83 | nâng ER patch đã khảo sát | facts quan sát không đổi |
| MT84 | đổi ER lặp | stock/population không drift |
| MT85 | flow retry qua shard | exactly-once theo flow id |
| MT86 | crash giữa outflow/inflow | recovery không mất/nhân lượng |
| MT87 | materialize A trước/sau B | kết quả giống khi input giống |
| MT88 | vùng xa có dịch | không biến mất khi người chơi tới |

### 102.12. Lưu tải và dài hạn

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| MT89 | save giữa storm | path/state/RNG giữ |
| MT90 | save giữa migration | count/individual không nhân đôi |
| MT91 | compaction lịch sử lũ | peak/footprint/cause anchors còn |
| MT92 | 100 năm vùng xa | resource/population bounds và history hợp lệ |
| MT93 | import mobile sang desktop | topology/flows/fingerprint giữ |
| MT94 | máy quá tải | backpressure không bỏ disaster/NPC |
| MT95 | Definition sinh thái đổi | migrate/pin/fail rõ |
| MT96 | generator 100 seed | invariants, diversity và shrink failure có evidence |

MT01–MT96 đều là điều kiện thiết kế chưa mã hóa và chưa chạy. Tổng hồ sơ tăng từ 1.380 lên 1.476 điều kiện thuộc 37 họ.

## 103. Cổng K4.4

| Cổng | Đạt khi | Hiện tại |
|---|---|---|
| K4E01 | spatial/geology/topology contract rõ | đạt trên giấy |
| K4E02 | climate–water–soil ledger rõ | đạt trên giấy |
| K4E03 | species–population–food web rõ | đạt trên giấy |
| K4E04 | disturbance/history không bị xóa | đạt trên giấy |
| K4E05 | linh sinh quyển dùng field/coupling | đạt trên giấy |
| K4E06 | ER0–ER5/save/mobile-desktop rõ | đạt trên giấy |
| K4E07 | schema/generator artifact tồn tại | chưa |
| K4E08 | K4E-F01–F16 mã hóa | chưa |
| K4E09 | MT01–MT96 chạy có evidence | chưa |
| K4E10 | 100 seed và dài hạn đạt budget | chưa |

## 104. Vấn đề mở

1. Hình dạng/quy mô thế giới và cosmology?
2. Mức chi tiết hình học địa hình chặng đầu?
3. Khí hậu An Khê và độ dài mùa?
4. Các chu trình dinh dưỡng canonical?
5. Danh mục loài ban đầu và nguồn dữ liệu?
6. Khi nào động vật trở thành cá thể có identity?
7. Evolution có cần trong thời lượng gameplay thường?
8. Cường độ và tần suất thiên tai?
9. Quy tắc sinh/hồi linh khí toàn cục?
10. Quan hệ linh mạch với địa chất và nước?
11. Có dị cảnh/law overlay ngay chặng đầu không?
12. Mức phá hủy địa hình/công trình?
13. Quyền đất/nước/tài nguyên theo văn hóa nào?
14. Người chơi được xem bản đồ môi trường sâu tới đâu?
15. Ngưỡng ER và error budget trên điện thoại?
16. K4.5 ưu tiên công pháp–cảnh giới hay NPC/xã hội sâu?

Chưa mục nào được tự chốt.

## 105. Rủi ro

| Rủi ro | Hậu quả | Kiểm soát đề xuất |
|---|---|---|
| mô phỏng từng lá/giọt | không chạy được | cohort, storage, flow, ER |
| biome là nhãn | môi trường giả | soil–water–population process |
| thời tiết reroll | lịch sử không thật | canonical on impact |
| vùng xa đứng yên | thế giới xoay quanh người chơi | seasonal solver/breakpoint |
| aggregate xóa tai họa | hậu quả biến mất | hotspot/extrema/anchor |
| sinh thái về cân bằng tức thì | thiếu lịch sử | lag, stages, succession |
| linh địa là mana node | thiếu chiều sâu | geology–field–ecology coupling |
| khai thác không có hậu quả | kinh tế vô hạn | deposit/landscape ledger |
| dữ liệu khoa học giả | thiếu tin cậy | provenance/calibration/ranges |
| UI quá dày | khó chơi mobile | knowledge-based drill-down |

## 106. Trình tự hiện thực hóa khi được yêu cầu

1. spatial hierarchy/topology và watershed graph.
2. water storage/flow F01–F04.
3. SoilProfile/erosion/nutrient F05–F06.
4. climate/weather canonical process.
5. Species/Habitat/Population/FoodWeb F07–F08.
6. disturbance fire/drought/flood F09–F10/F16.
7. land use, extraction, pollution, irrigation F11–F12.
8. spiritual network/ecology F13–F14.
9. ER0–ER5, save/replay và parity F15.
10. generator/prehistory/100-seed audit.
11. mã hóa MT01–MT96 và chạy evidence.

Đây là thứ tự triển khai tương lai, chưa phải việc đã làm.

## 107. Những điều không được tuyên bố

- Không nói đã sinh thế giới, khí hậu hoặc hệ sinh thái.
- Không nói các mô hình là chính xác khoa học.
- Không nói đã có từng cây/con vật ngoài fixture.
- Không nói đã chốt loài, mùa, linh mạch hoặc cosmology.
- Không nói ER0–ER5 đã đạt parity.
- Không nói MT01–MT96 đã mã hóa/chạy.
- Không nói 1.476 điều kiện là test tự động.
- Không nói game đã chạy trên điện thoại/máy tính.

## 108. Giá trị K4.4 cung cấp thật

- địa lý theo topology/lưu vực thay vì nền bản đồ tĩnh;
- khí hậu và thời tiết có continuity cùng lịch sử cố định;
- nước, đất, chất và ô nhiễm có ledger xuyên vùng;
- quần thể/mạng thức ăn tự phản hồi qua thời gian;
- thiên tai, diễn thế và suy kiệt để lại dấu vết;
- linh mạch gắn địa chất–sinh thái–cộng đồng;
- ER0–ER5 giữ thế giới xa sống mà phù hợp đa nền tảng;
- 16 fixture và 96 điều kiện có thể mã hóa sau.

## 109. Bước tiếp theo

K4.5–K4.8 đã định tu luyện, NPC, xã hội và chiến đấu. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chưa lập trình.

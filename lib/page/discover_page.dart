import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tracker/widgets/movie_page.dart';
import '../utils/fetch_data.dart';
import 'dart:convert';
import '../utils/data_structure.dart';
import '../widgets/search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cache_data/cachedata.dart';

// 这里使用了GetX状态库，不然无限滚动实现不了，太难了
class Controller extends GetxController {
  ScrollController scrollController = ScrollController();
  List<SingleMovie> movieData = [];
  var isLoading = false;
  int _page = 1;

  void getMovieDataReady() {
    movieData = cache_data.instance.MovieData;
  }

  int movieDataLength() {
    update();
    int moviedataLength = 0;
    moviedataLength = movieData.length + (isLoading ? 1 : 0);
    return moviedataLength;
  }

  void loadMore() {
    // 当监测到划到最底部时，加载下一个page
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading) {
      isLoading = true;
      update();
      fetchDiscoverData(_page + 1).then((value) {
        // 新数据和旧数据的拼接
        movieData.addAll(value);
        // 增加新的页面
        _page++;
        isLoading = false;
        update();
      }).catchError((error) {
        debugPrint('发生错误：$error');
      });
    }
  }

  static Controller get to => Get.find();

  @override
  // 这是页面一打开就会运行的函数
  void onInit() {
    // 初始化一些数据
    // String jsonStr = """
    // {
    // "page":1,
    // "results":[{"adult":false,
    //             "backdrop_path":"/1XDDXPXGiI8id7MrUxK36ke7gkX.jpg",
    //             "genre_ids":[28,12,16,35,10751],
    //             "id":1011985,
    //             "original_language":"en",
    //             "original_title":"Kung Fu Panda 4",
    //             "overview":"神龙大侠阿宝（杰克·布莱克 Jack Black 配音）再度归来，要被师父（达斯汀·霍夫曼 Dustin Hoffman 配音）强行进阶修行。系列全新最强反派魅影妖后（维奥拉·戴维斯 Viola Davis 配音）登场，神秘莫测的她可以幻化成每一个阿宝的昔日宿敌。此次阿宝又结识了小真（奥卡菲娜 Awkwafina 配音）等新伙伴，并将一同开启这场冒险旅程。",
    //             "popularity":5151.423,
    //             "poster_path":"/pYjnEO9QRDURuYUgdZxcRZ0G7VH.jpg",
    //             "release_date":"2024-03-02",
    //             "title":"功夫熊猫4",
    //             "video":false,
    //             "vote_average":6.8,
    //             "vote_count":239
    //             },
    //             {"adult":false,"backdrop_path":"/zAepSrO99owYwQqi0QG2AS0dHXw.jpg","genre_ids":[28,14],"id":634492,"original_language":"en","original_title":"Madame Web","overview":"身为急救护工的凯茜（达科塔·约翰逊 Dakota Johnson 饰）某天意外发现自己具有预知未来的能力，在复杂时空和交错命运的安排下，她成为蜘蛛夫人，与三位蜘蛛女建立了深厚的友谊。当重重危险逐步逼近，她们能否成功化解危机？","popularity":2288.399,"poster_path":"/vX6F4dv9AavdVbLE0C6N3mwLqnw.jpg","release_date":"2024-02-14","title":"蜘蛛夫人：超感觉醒","video":false,"vote_average":5.555,"vote_count":658},{"adult":false,"backdrop_path":"/deLWkOLZmBNkm8p16igfapQyqeq.jpg","genre_ids":[9648,14,28,12],"id":763215,"original_language":"en","original_title":"Damsel","overview":"年轻公主艾洛蒂答应嫁给英俊王子亨利，却骇然发现王室打算将她献祭给一头巨龙，以偿还家族代代相传的古老债务。惨被当成祭品的她被无情地扔进洞穴，面对张牙舞爪的喷火恶龙，她必须靠着勇气与智慧逃出生天。","popularity":1465.407,"poster_path":"/nk5Ex2FSXtTA1RTzhlU6yvK9K6x.jpg","release_date":"2024-03-08","title":"少女斗恶龙","video":false,"vote_average":7.177,"vote_count":1043},{"adult":false,"backdrop_path":"/oFAukXiMPrwLpbulGmB5suEZlrm.jpg","genre_ids":[28,12,878,14,18],"id":624091,"original_language":"id","original_title":"Sri Asih","overview":"斯里阿西与父母失散被一位富婆收养，当她成年后她发现了自己起源的真相。","popularity":1116.432,"poster_path":"/lMZWF6Bm8MkFHjL9PHgUzHuuYfi.jpg","release_date":"2022-11-17","title":"神奇女侠斯里阿西","video":false,"vote_average":6.432,"vote_count":37},{"adult":false,"backdrop_path":"/mDeUmPe4MF35WWlAqj4QFX5UauJ.jpg","genre_ids":[28,27,53],"id":1096197,"original_language":"pt","original_title":"No Way Up","overview":"一架满载游客的飞机起飞后突然起火，坠入太平洋深海中，惊魂未定的乘客被困机舱气囊中，氧气已所剩无几，大难不死的乘客以及机组人员正要开始庆祝，却遭到了几只嗜血鲨鱼的袭击，在深不见底的太平洋，鲨鱼群对他们展开凶猛的攻击，求生心切，幸存者们展开了人鲨大战。","popularity":910.182,"poster_path":"/ktxq0LYgl41I2DUn49TYIaS9dZR.jpg","release_date":"2024-01-18","title":"深渊鲨难","video":false,"vote_average":6.15,"vote_count":264},{"adult":false,"backdrop_path":"/xvk5AhfhgQcTuaCQyq3XqAnhEma.jpg","genre_ids":[28,12,35],"id":848538,"original_language":"en","original_title":"Argylle","overview":"艾莉·康威是一名畅销谍战小说作家，个性孤僻、生活低调，平常最喜欢宅在家，一边打电脑一边陪她的爱猫阿飞玩。但是当她笔下虚构故事中的情节：机密特工阿盖尔执行一项企图破获一个全球间谍组织的危险任务，竟然呼应了现实世界中一个特工组织的机密行动时，她安稳平静的居家生活从此就被搞得天翻地覆。 于是在对猫咪过敏的特工艾登的伴随下，艾莉为了逃避职业杀手的追杀，就必须和时间赛跑，在世界各地展开冒险，她笔下的虚构世界和现实世界的一线之隔也越来越模糊。","popularity":879.907,"poster_path":"/A6hlmdQzqz1JHLhhfoBnGjJnexA.jpg","release_date":"2024-01-31","title":"阿盖尔：神秘特工","video":false,"vote_average":6.15,"vote_count":665},{"adult":false,"backdrop_path":"/87IVlclAfWL6mdicU1DDuxdwXwe.jpg","genre_ids":[878,12],"id":693134,"original_language":"en","original_title":"Dune: Part Two","overview":"保罗·厄崔迪与契妮和弗雷曼人联手，踏上对致其家毁人亡的阴谋者的复仇之路。当面对一生挚爱和已知宇宙命运之间的抉择时，他必须努力阻止只有他能预见的可怕的未来。","popularity":746.796,"poster_path":"/1p25wDEdFRRTtwtPFbtPHISefzG.jpg","release_date":"2024-02-27","title":"沙丘2","video":false,"vote_average":8.395,"vote_count":1989},{"adult":false,"backdrop_path":"/u0P5drNyTrZoGyJONPcZGbv1mNP.jpg","genre_ids":[28,53],"id":1124127,"original_language":"en","original_title":"Air Force One Down","overview":"在空军一号上执行的第一项任务中，一名新特勤局特工面临着终极考验，恐怖分子劫持了这架飞机，意图破坏一项关键的能源交易。 随着总统的生命垂危，全球危机岌岌可危，她的勇气和技能在一场可能改变历史进程的无情战斗中被推向极限。","popularity":725.718,"poster_path":"/nKPoSD4pZ3s3CJ9g3cqWRcQ41TC.jpg","release_date":"2024-02-09","title":"空军一号坠落","video":false,"vote_average":6.1,"vote_count":33},{"adult":false,"backdrop_path":"/47olX0FCvUCfAqlp8cK0O5fKLav.jpg","genre_ids":[16,35,878],"id":1239251,"original_language":"en","original_title":"Megamind vs. the Doom Syndicate","overview":"　　讲述超级大坏蛋（Megamind）要保护城市，对付强大的对手。而为了做到，他必须保持伪装，“行为像反派，思路像超级英雄”。  　　梅格玛（超级大坏蛋 Megamind）的前反派团队“毁灭联盟”回来了。我们新加冕的蓝色英雄现在必须保持邪恶的外表，直到他能召集他的朋友（罗克珊 Roxanne，老朋友 Ol' Chum和桂子 Keiko）阻止他的前恶棍队友将大都市发射到月球。","popularity":717.902,"poster_path":"/yRZfiG1QpRkBc7fAmxfcR7Md5EC.jpg","release_date":"2024-03-01","title":"超级大坏蛋大战末日集团","video":false,"vote_average":5.631,"vote_count":130},{"adult":false,"backdrop_path":"/qVrS8bu1B7G1tgLTlCZQi4CFsTh.jpg","genre_ids":[28,53,10752],"id":969492,"original_language":"en","original_title":"Land of Bad","overview":"一支特种部队前往菲律宾南部执行一项紧急救援任务，代号“死神”（罗素克洛 饰）的空军无人机驾驶奉命操作“MQ-9死神无人机”进行空中支援，但救援过程却意外出了差错，特种部队因而遭受武装民兵猛烈攻击。面对突如其来的危机，“死神”必须想办法在短短48小时内扭转失控的救援行动，而他来自天空的指引，将成为身陷绝境的特种部队成功拯救人质并逃出生天的唯一希望...","popularity":716.772,"poster_path":"/khmQoGP39zfrESdHR1BzSf84JTF.jpg","release_date":"2024-01-25","title":"惊天激战","video":false,"vote_average":7.081,"vote_count":394},{"adult":false,"backdrop_path":"/gklkxY0veMajdCiGe6ggsh07VG2.jpg","genre_ids":[16,28,12,35,10751],"id":940551,"original_language":"en","original_title":"Migration","overview":"飞鸭马拉德一家向南迁徙前往热带的牙买加，却意外闯入疯狂大都市纽约？在紧张刺激的飞行之旅中，他们将如何化险为夷？","popularity":689.368,"poster_path":"/t6LAjw9C2fGYZy7zLmtEkcnC5UM.jpg","release_date":"2023-12-06","title":"飞鸭向前冲","video":false,"vote_average":7.559,"vote_count":972},{"adult":false,"backdrop_path":"/cu5Qk2QHxOyyMrD3Bq93DxgmJer.jpg","genre_ids":[28,80],"id":1046090,"original_language":"zh","original_title":"周處除三害","overview":"通缉犯陈桂林（阮经天 饰）生命将尽，却发现自己在通缉榜上只排名第三，他决心查出前两名通缉犯的下落，并将他们一一除掉。陈桂林以为自己已成为当代的周处除三害，却没想到永远参不透的贪嗔痴，才是人生终要面对的罪与罚。 影片引用的“周处除三害”典故，见于《晋书·周处传》和《世说新语》。据记载，少年周处身形魁梧，武力高强，却横行乡里，为邻人所厌。后周处只身斩杀猛虎孽蛟，他自己也浪子回头、改邪归正，至此三害皆除。","popularity":675.022,"poster_path":"/eNvuf4PHepy0nlXfludjGCJGG59.jpg","release_date":"2023-10-06","title":"周处除三害","video":false,"vote_average":7.48,"vote_count":101},{"adult":false,"backdrop_path":"/bQS43HSLZzMjZkcHJz4fGc7fNdz.jpg","genre_ids":[878,10749,35],"id":792307,"original_language":"en","original_title":"Poor Things","overview":"维多利亚·布莱辛顿为了逃避虐待她的丈夫而不幸溺水身亡，但外科医生从她孕育的胎儿中取出大脑，植入到她的头骨中，使她重生为贝拉·巴克斯特。复活的贝拉从而有了一个孩子的心理年龄。在与医生麦坎德莱斯订婚后，贝拉用氯仿迷昏了医生，并和一个阴暗的律师逃跑。律师带着贝拉踏上冒险之旅，一路从埃及的亚历山大到黑海西北岸的敖德萨，再到巴黎的妓院。随着贝拉的大脑变得成熟，贝拉逐渐形成了一种社会良知，但当她的合法丈夫奥布里·布莱辛顿爵士认出其为维多利亚时，她改期嫁给麦坎德莱斯的计划不得不缩短。","popularity":664.692,"poster_path":"/5XJRtk8C0jB5eLXM9Nubz8M8uCN.jpg","release_date":"2023-12-07","title":"可怜的东西","video":false,"vote_average":7.855,"vote_count":2561},{"adult":false,"backdrop_path":"/ekRp1sEA8pnuzVHQkUESTgNSKdW.jpg","genre_ids":[878,28,80],"id":932420,"original_language":"en","original_title":"Code 8 Part II","overview":"在一个权贵阶级受到监督和压迫的城市，为了保护一个少年免受腐败警察的侵害，这名前科犯不得不向自己鄙夷的毒枭求助。","popularity":648.177,"poster_path":"/uwCNoa99updIa2Zy9OMuhmFwNXy.jpg","release_date":"2024-02-27","title":"8号警报2","video":false,"vote_average":6.558,"vote_count":320},{"adult":false,"backdrop_path":"/4Ep2KivIBUZbkS7kHjW7Qywnhhj.jpg","genre_ids":[28],"id":1049948,"original_language":"en","original_title":"Vikings: Battle of Heirs","overview":"","popularity":629.338,"poster_path":"/87goLbbqrJqAxqDS5cBsik1zKT.jpg","release_date":"2023-04-28","title":"Vikings: Battle of Heirs","video":false,"vote_average":7.75,"vote_count":4},{"adult":false,"backdrop_path":"/1ZSKH5GGFlM8M32K34GMdaNS2Ew.jpg","genre_ids":[10402,36,18],"id":802219,"original_language":"en","original_title":"Bob Marley: One Love","overview":"一位人物，一个信念，一场革命，一个传奇。 影片聚焦鲍勃·马利短暂的36年人生中的故事，比如他为音乐带来的巨大改变、那些传奇性的作品，和在牙买加的重要地位等。","popularity":611.369,"poster_path":"/hxGoPNMzOwpboGEXTJRkJjJx9H8.jpg","release_date":"2024-02-14","title":"鲍勃·马利：一份爱","video":false,"vote_average":6.95,"vote_count":309},{"adult":false,"backdrop_path":"/sR0SpCrXamlIkYMdfz83sFn5JS6.jpg","genre_ids":[28,878,12],"id":823464,"original_language":"en","original_title":"Godzilla x Kong: The New Empire","overview":"继上一次的怪兽高燃对战之后，金刚和哥斯拉将再度联手对抗一个潜伏在世界中的巨大威胁，并逐步探索这些巨兽们的起源以及骷髅岛等地的奥秘。同时，上古之战的面纱也将会被揭晓，而正是那场战斗创造出了这些超凡的生物，并深刻影响了人类世界的命运。","popularity":575.752,"poster_path":"/1hUTqPnfTvuupk7XW7WCkWYW4M1.jpg","release_date":"2024-03-27","title":"哥斯拉大战金刚2：帝国崛起","video":false,"vote_average":0,"vote_count":0},{"adult":false,"backdrop_path":"/nTPFkLUARmo1bYHfkfdNpRKgEOs.jpg","genre_ids":[10749,35],"id":1072790,"original_language":"en","original_title":"Anyone But You","overview":"男才女貌的Bea和 Ben在初次约会时就发生一件天大误会，令二人恋人未满就变仇人。谁知天意弄人，他们竟在一场异地婚礼上重逢！面对亲朋戚友大大力的推波助澜，各怀鬼胎的二人决定顺 应民意假扮情侣。在仇人和情侣之间，你来我往，狠狠恋上。","popularity":539.614,"poster_path":"/1SexNjgm9b0sHJiOaIWf1pghcs2.jpg","release_date":"2023-12-21","title":"只想爱你","video":false,"vote_average":7.09,"vote_count":1071},{"adult":false,"backdrop_path":"/i7nnmCTnjK50vNqbMfVtmoVULWJ.jpg","genre_ids":[28],"id":1081620,"original_language":"en","original_title":"The Weapon","overview":"达拉斯（Dallas）是一个神秘的杀人机器。他对机车团伙和冰毒实验室的袭击激怒了拉斯维加斯黑帮老大，后者将达拉斯的女友作为人质。但达拉斯为谁工作？即使是酷刑也不会让他说话，在正义得到伸张之前，他不会停止。","popularity":530.838,"poster_path":"/slQYCDzCMM8SBh9Xa3aPeM2fekA.jpg","release_date":"2023-02-17","title":"致命武器","video":false,"vote_average":5.382,"vote_count":17},{"adult":false,"backdrop_path":"/yyFc8Iclt2jxPmLztbP617xXllT.jpg","genre_ids":[35,10751,14],"id":787699,"original_language":"en","original_title":"Wonka","overview":"威利·旺卡，充满创意并决心一口一口改变世界，证明了生活中最美好的事物始于梦想。如果你足够幸运地遇到威利·旺卡，一切皆有可能。","popularity":496.802,"poster_path":"/iBh9D95rKBj3cbUM2gYIL0NLW57.jpg","release_date":"2023-12-06","title":"旺卡","video":false,"vote_average":7.208,"vote_count":2602}],"total_pages":43160,"total_results":863199}
    // """;
    // List<dynamic> jsonData = jsonDecode(jsonStr)['results'];
    // movieData = jsonData
    //     .map<SingleMovie>((item) => SingleMovie.fromJson(item))
    //     .toList();
    getMovieDataReady();
    scrollController = ScrollController();
    isLoading = false;
    // 添加滚动监听器
    scrollController.addListener(loadMore);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBar(
            hintText: 'Enter your search query',
            leading: const Icon(Icons.search),
            onTap: () {
              Get.to(SearchBarView(), transition: Transition.fade);
            },
          ),
          Expanded(
            child: GetBuilder<Controller>(
              init: Controller(),
              builder: (controller) {
                return MasonryGridView.count(
                  controller: controller.scrollController,
                  crossAxisCount: 2,
                  itemCount: controller.movieDataLength(),
                  itemBuilder: (context, index) {
                    if (index < controller.movieData.length) {
                      // 单个电影卡片，传入一个singleMovie变量
                      return MovieCard(movie: controller.movieData[index]);
                    } else {
                      // 加载转圈圈的进度条
                      return const LoadingView();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 加载转圈圈的进度条
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: SizedBox(
          width: 18.0,
          height: 18.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.grey,
            ),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}

// 生成电影卡片的界面
// TODO: 美化
class MovieCard extends StatelessWidget {
  SingleMovie movie;

  MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击就导航到MoviePage
      onTap: () {
        Get.to(MoviePage(movie: movie), transition: Transition.fadeIn);
      },
      // 一个电影美化过的卡片
      child: Card(
        elevation: 10, // 抬起的阴影
        clipBehavior: Clip.antiAlias, // 设置抗锯齿
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ), // 设置圆角
        margin: const EdgeInsets.all(8),
        child: Stack(
          textDirection: TextDirection.rtl,
          fit: StackFit.loose,
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            // 获取网络图片并缓存，
            CachedNetworkImage(
              imageUrl: "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 50, 5, 10),
              // 设置阴影
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'TMDB评分：${movie.voteAverage} (${movie.voteCount})',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

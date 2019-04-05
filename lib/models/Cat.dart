class Cat {
  final String id;
  final String name;
  final String origin;
  final String description;
  final String wikipediaUrl;
  final List<String> images;
  final String temperament;
  //
  final int intelligence;
  final int healthIssues;
  final int energyLevel;
  final int adaptability;
  final int affectionLevel;
  final int grooming;
  final int sheddingLevel;
  final int vocalisation;
  //
  final int isRare;
  final int isRex;
  final int isHairless;
  final int isNatural;
  final int isExperimental;

  Cat({this.id, this.name, this.origin, this.description, this.wikipediaUrl,
      this.images, this.temperament, this.intelligence, this.healthIssues, this.energyLevel,
      this.adaptability, this.affectionLevel, this.grooming, this.sheddingLevel,
      this.vocalisation, this.isRare, this.isRex, this.isHairless,
      this.isNatural, this.isExperimental});

  static List<Cat> getCatsFromJson(List data) {
    final cats = new List<Cat>();
    for (var d in data) {
      cats.add(Cat.fromJson(d));
    }

    return cats;
  }

  factory Cat.fromJson(Map<String, dynamic> body) {
    final breed = body['breeds'][0];
    final url = new List<String>();
    url.add(body['url']);
    final cat = Cat(
      id: breed['id'],
      name: breed['name'],
      origin: breed['origin'],
      description: breed['description'],
      wikipediaUrl: breed['wikipedia_url'],
      images: url,
      temperament: breed['temperament'],
      intelligence: breed['intelligence'],
      healthIssues: 5 - breed['health_issues'],
      energyLevel: breed['energy_level'],
      adaptability: breed['adaptability'],
      affectionLevel: breed['affection_level'],
      grooming: breed['grooming'],
      sheddingLevel: breed['shedding_level'],
      vocalisation: breed['vocalisation'],
      isRare: breed['rare'],
      isRex: breed['rex'],
      isHairless: breed['hairless'],
      isNatural: breed['natural'],
      isExperimental: breed['experimental'],);
    //cat.getImage();
    return cat;
  }

  addImage(String url) {
    this.images.add(url);
  }
}

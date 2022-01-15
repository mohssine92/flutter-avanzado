// es un modelos que maneja la informacion de band .

class Band {
  String id;
  String name;
  // va ser cantidades de votos que va tener instancia banda
  int votes;

  // construstor - {...} arg por nombre - existe args por posicion en otros casos
  Band({required this.id, required this.name, required this.votes});

  // cuando connectamos con back-server - va responder mapa , No string - porque vamos a implementar comunicacion por Socket .

  // Factory Constructor : no es ada mas que es un constructor que recibe cierta data y regresa nueva Instancia de mi Band o de mi class - Nombre de este Factory is : fromMap
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 0);
  // {return Band(etc)} sustituido por funcion de flecha
}

import 'dart:convert';

import 'package:saporra/core/consts/app_local_storage_keys.dart';
import 'package:saporra/core/errors/app_exception.dart';
import 'package:saporra/models/bill.dart';
import 'package:saporra/models/member.dart';
import 'package:saporra/services/local_storage_service.dart';

class MembersRepository {
  static const String _key = AppLocalStorageKeys.members;
  final LocalStorageService _localStorage;

  const MembersRepository(this._localStorage);

  Future<void> _saveList(List<Person> bills) async {
    final list = bills.map((el) => el.toMap()).toList();
    await _localStorage.write(_key, jsonEncode(list));
  }

  Future<List<Person>> getAll() async {
    final value = await _localStorage.read(_key);
    if (value == null || value.isEmpty) {
      return [];
    }

    try {
      return List.from(jsonDecode(value)).map((e) => Person.fromMap(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Person>> getAllByBill(Bill bill) async {
    try {
      final members = await getAll();
      return members.where((el) => bill.membersIds.contains(el.id)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> add(Person newPerson) async {
    final persons = await getAll();
    if (persons.contains(newPerson)) {
      throw const AppException('Pessoa já existe');
    }
    persons.add(newPerson);
    await _saveList(persons);
  }

  Future<void> remove(Person person) async {
    final persons = await getAll();
    if (!persons.contains(person)) {
      throw const AppException('Pessoa não existente');
    }
    persons.remove(person);
    await _saveList(persons);
  }

  Future<void> edit(Person person) async {
    final persons = await getAll();
    final index = persons.indexWhere((el) => el.id == person.id);
    if (index < 0) {
      throw const AppException('Pessoa não existente');
    }
    persons[index] = person;
    await _saveList(persons);
  }
}

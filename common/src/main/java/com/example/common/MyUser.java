package com.example.common;

public class MyUser {
	private String name;

	public MyUser(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	@Override
	public String toString() {
		return "MyUser{" +
				"name='" + name + '\'' +
				'}';
	}
}

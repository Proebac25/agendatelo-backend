package com.proebac25.pwa_sql_java.controller;

import com.proebac25.pwa_sql_java.model.User;
import com.proebac25.pwa_sql_java.repository.UserRepository;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    @Autowired
    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<User> getAll() {
        return userRepository.findAll();
    }
}

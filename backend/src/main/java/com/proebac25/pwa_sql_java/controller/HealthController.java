package com.proebac25.pwa_sql_java.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.OffsetDateTime;
import java.util.Map;

@RestController
public class HealthController {

    @GetMapping("/api/health")
    public ResponseEntity<Map<String, Object>> health() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "project", "PWA_SQL_JAVA_RESTART",
            "backend", "Spring Boot 3.5.7",
            "database", "Supabase (agendatelo-prod)",
            "timestamp", OffsetDateTime.now().toString()
        ));
    }
}
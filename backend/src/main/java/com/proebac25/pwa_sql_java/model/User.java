package com.proebac25.pwa_sql_java.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    private String full_name;
    private String phone;
    private String bio_description;
    private String location_city;
    private Boolean verified;
    private Boolean is_active;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFull_name() { return full_name; }
    public void setFull_name(String full_name) { this.full_name = full_name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getBio_description() { return bio_description; }
    public void setBio_description(String bio_description) { this.bio_description = bio_description; }

    public String getLocation_city() { return location_city; }
    public void setLocation_city(String location_city) { this.location_city = location_city; }

    public Boolean getVerified() { return verified; }
    public void setVerified(Boolean verified) { this.verified = verified; }

    public Boolean getIs_active() { return is_active; }
    public void setIs_active(Boolean is_active) { this.is_active = is_active; }

    public LocalDateTime getCreated_at() { return created_at; }
    public void setCreated_at(LocalDateTime created_at) { this.created_at = created_at; }

    public LocalDateTime getUpdated_at() { return updated_at; }
    public void setUpdated_at(LocalDateTime updated_at) { this.updated_at = updated_at; }
}

package com.proebac25.pwa_sql_java;

import com.proebac25.pwa_sql_java.model.User;
import com.proebac25.pwa_sql_java.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
public class PwaSqlJavaApplication {

    public static void main(String[] args) {
        SpringApplication.run(PwaSqlJavaApplication.class, args);
    }

    @Bean
    CommandLineRunner initData(UserRepository userRepository) {
        return args -> {
            try {
                final String seedEmail = "miguel@example.com";

                // Comprobación idempotente usando métodos garantizados por JpaRepository
                boolean exists = userRepository.findAll()
                        .stream()
                        .anyMatch(u -> seedEmail.equalsIgnoreCase(u.getEmail()));

                if (!exists) {
                    User user = new User();
                    // Usa los setters según tu entidad
                    user.setFull_name("Miguel García");
                    user.setEmail(seedEmail);
                    user.setPhone("123456789");
                    user.setLocation_city("Madrid");
                    user.setBio_description("Desarrollador PWA");
                    user.setIs_active(true);
                    user.setVerified(true);

                    userRepository.save(user);
                    System.out.println("Seed user created: " + seedEmail);
                } else {
                    System.out.println("Seed user already exists: " + seedEmail);
                }
            } catch (Exception ex) {
                // No interrumpir el arranque por problemas en la semilla
                System.err.println("Init seed skipped (non-fatal): " + ex.getMessage());
            }
        };
    }

    @Configuration
    static class WebConfig implements WebMvcConfigurer {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/api/**")
                    .allowedOrigins(
                        "http://localhost:3000",
                        "https://agendatelo-frontend.vercel.app"
                    )
                    .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                    .allowCredentials(true);
        }
    }
}

package com.example.voiture;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CarController {

    @GetMapping("/api/cars/byClient/{clientId}")
    public Car getCar(@PathVariable Long clientId) {
        try {
            Thread.sleep(50);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return new Car(10L, "Toyota", "Yaris", clientId);
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    static class Car {
        private Long id;
        private String marque;
        private String modele;
        private Long clientId;
    }
}

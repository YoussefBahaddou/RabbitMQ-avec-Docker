package com.example.client;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.client.WebClient;

@RestController
@AllArgsConstructor
public class ClientController {

    private final RestTemplate restTemplate;
    private final CarFeignClient carFeignClient;
    private final WebClient.Builder webClientBuilder;

    @GetMapping("/api/clients/{id}/car/rest")
    public Object getCarRest(@PathVariable Long id) {
        return restTemplate.getForObject("http://service-voiture/api/cars/byClient/" + id, Object.class);
    }

    @GetMapping("/api/clients/{id}/car/feign")
    public Object getCarFeign(@PathVariable Long id) {
        return carFeignClient.getCar(id);
    }

    @GetMapping("/api/clients/{id}/car/webclient")
    public Object getCarWebClient(@PathVariable Long id) {
        return webClientBuilder.build()
                .get()
                .uri("http://service-voiture/api/cars/byClient/" + id)
                .retrieve()
                .bodyToMono(Object.class)
                .block();
    }
}

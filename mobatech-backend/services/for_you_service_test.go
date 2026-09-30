package services

import (
	"testing"
)

func TestForYouService_PersonalizedFallbackTopics(t *testing.T) {
	svc := &forYouService{}

	cardioArticles := svc.getPersonalizedFallback("Dada saya terasa nyeri dan detak jantung berdebar")
	if len(cardioArticles) == 0 {
		t.Fatalf("expected cardio fallback articles, got 0")
	}
	if cardioArticles[0].Category != "Poli Jantung" {
		t.Errorf("expected Poli Jantung, got %s", cardioArticles[0].Category)
	}

	pediatricArticles := svc.getPersonalizedFallback("Anak saya demam tinggi sudah 2 hari dan tidak mau makan")
	if len(pediatricArticles) == 0 {
		t.Fatalf("expected pediatric fallback articles, got 0")
	}
	if pediatricArticles[0].Category != "Poli Anak" {
		t.Errorf("expected Poli Anak, got %s", pediatricArticles[0].Category)
	}

	internalArticles := svc.getPersonalizedFallback("Perut saya perih dan mual seperti gejala maag gerd")
	if len(internalArticles) == 0 {
		t.Fatalf("expected internal medicine fallback articles, got 0")
	}
	if internalArticles[0].Category != "Penyakit Dalam" {
		t.Errorf("expected Penyakit Dalam, got %s", internalArticles[0].Category)
	}

	generalArticles := svc.getPersonalizedFallback("Halo apa kabar")
	if len(generalArticles) == 0 {
		t.Fatalf("expected general fallback articles, got 0")
	}
	if generalArticles[0].Category != "Kesehatan Umum" {
		t.Errorf("expected Kesehatan Umum, got %s", generalArticles[0].Category)
	}
}

func TestForYouService_NormalizeArticles(t *testing.T) {
	svc := &forYouService{}
	rawArticles := []Article{
		{Title: "Tips Jantung Sehat", Category: "Kardiovaskular"},
	}
	normalized := svc.normalizeArticles(rawArticles)
	if len(normalized) != 1 {
		t.Fatalf("expected 1 normalized article")
	}
	if normalized[0].ID == "" {
		t.Errorf("expected ID to be filled, got empty")
	}
	if normalized[0].Tag == "" {
		t.Errorf("expected Tag to be filled, got empty")
	}
	if normalized[0].ActionText == "" {
		t.Errorf("expected ActionText to be filled, got empty")
	}
	if normalized[0].ActionRoute == "" {
		t.Errorf("expected ActionRoute to be filled, got empty")
	}
}

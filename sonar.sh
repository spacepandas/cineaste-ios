#!/usr/bin/env bash

sonar-scanner \
  -Dsonar.projectKey=spacepandas_cineaste-ios \
  -Dsonar.projectName=cineaste-ios \
  -Dsonar.organization=spacepandas \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.login=$SONAR \
  -Dsonar.sourceEncoding=UTF-8 \
  -Dsonar.language=swift \
  -Dsonar.inclusions=**.swift \
  -Dsonar.sources=Cineaste \
  -Dsonar.tests=CineasteTests,CineasteUITests \
  -Dsonar.test.inclusions=CineasteTests/**,CineasteUITests/** \
  -Dsonar.log.level=WARN \
  -Dsonar.swift.coverage.reportPath=report.llcov

#!/usr/bin/env bash

bash \
  ./xccov-to-sonarqube-generic.sh \
  DerivedData/Logs/Test/*.xcresult/*_Test/action.xccovarchive/ \
  > sonarqube-generic-coverage.xml

sonar-scanner \
  -Dsonar.projectKey=spacepandas_cineaste-ios \
  -Dsonar.projectName=cineaste-ios \
  -Dsonar.organization=spacepandas \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.sourceEncoding=UTF-8 \
  -Dsonar.language=swift \
  -Dsonar.inclusions=**.swift \
  -Dsonar.sources=Cineaste \
  -Dsonar.tests=CineasteTests,CineasteUITests \
  -Dsonar.test.inclusions=CineasteTests/**,CineasteUITests/** \
  -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml

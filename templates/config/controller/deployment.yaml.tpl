apiVersion: v1
kind: Namespace
metadata:
  labels:
    control-plane: controller
  name: ack-system
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ack-{{ .ServiceIDClean }}-controller
  namespace: ack-system
  labels:
    control-plane: controller
spec:
  selector:
    matchLabels:
      control-plane: controller
  replicas: 1
  template:
    metadata:
      labels:
        control-plane: controller
    spec:
      containers:
      - command:
        - ./bin/controller
        args:
        - --aws-account-id
        - "$(AWS_ACCOUNT_ID)"
        - --aws-region
        - "$(AWS_REGION)"
        - --enable-development-logging
        - "$(ACK_ENABLE_DEVELOPMENT_LOGGING)"
        image: controller:latest
        name: controller
        resources:
          limits:
            cpu: 100m
            memory: 300Mi
          requests:
            cpu: 100m
            memory: 200Mi
        env:
        - name: K8S_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
      terminationGracePeriodSeconds: 10

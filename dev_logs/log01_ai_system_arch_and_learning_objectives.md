# Orvexa Development Log

## AI System Architecture & Learning Objectives

**Date:** 2026-09-12
**Project:** Orvexa
**Domain:** Generative Media Creation
**Engineering Focus:** AI System Design / Harness Engineering / Agentic Engineering / Post-training

---

## 1. 项目定位

Orvexa 的最终业务目标确定为：

> **A harness-driven generative media system for controllable and verifiable media creation.**

系统以 **Media Creation** 为核心业务，主要输出 Image、Video 和相关 Media Assets。

Interactive AI 不作为独立业务方向。Dialogue、Agent 和 UE5 均作为辅助 Media Creation 的能力存在。

其中：

* **WAN / Media Model**：负责实际图像、视频生成。
* **LLM / Agent**：理解用户创作意图，将自然语言转换为结构化 Creative Specification，并负责部分 workflow decision。
* **UE5**：作为可控 Scene Environment，为 camera、lighting、pose、spatial layout 等提供 reference、grounding 和辅助验证。
* **VLM / CV / Evaluator**：分析生成结果并验证其是否满足用户要求。
* **Harness**：连接并控制以上模型、环境和工具，使概率性的模型能力成为相对可靠的系统能力。

因此，Dialogue 和 UE5 的最终目的仍然是：

> **Improve controllability, verifiability and semantic reliability of media creation.**

---

# 2. 项目的两个不同目标

必须区分 **Business Goal** 和 **Learning Goal**。

### Business Goal

构建一个相对简单但完整的 Generative Media Creation application：

```text
User Intent
    ↓
Creative Specification
    ↓
UE5 Scene / Reference
    ↓
Media Conditions
    ↓
WAN Generation
    ↓
Verification
    ↓
Image / Video
```

业务范围需要保持克制，不把项目扩展成通用 Agent Platform、聊天机器人或者完整游戏。

### Learning Goal

项目真正更重要的目的，是通过一个真实 AI application 系统学习：

```text
AI System Design
+
Distributed Systems
+
Harness Engineering
+
Agentic Engineering
+
Model Post-training Lifecycle
```

目标职业能力倾向：

> **Agentic AI Engineer / AI Systems Engineer**

因此部分技术对于当前业务规模可能属于 over-engineering，但如果能够帮助理解重要的 System Design 问题，可以采用**最小实现**加入项目。

原则是：

> Implementation can be minimal, but the design problem should not be skipped.

---

# 3. AI System 的基本认识

传统软件系统主要依赖：

```text
Code + Data + Infrastructure
```

AI System 增加了：

```text
Code
+
Model
+
Harness
+
State / Data
+
Infrastructure
```

模型本身具有概率性，因此传统意义上的程序运行成功并不代表任务成功。

例如：

```text
HTTP 200
+
WAN successfully generated video
```

不能证明：

```text
User Intent was satisfied
```

因此 AI System 除传统 Functional / Non-functional Requirements 外，需要特别考虑：

> **Semantic Correctness / Semantic Reliability**

---

# 4. Harness 的定位

Harness 不仅定义为简单的 Agent Framework，也不只定义为 Inference Runtime。

更广义地：

> **Harness 是围绕模型生命周期，对模型执行、环境交互、质量控制和学习过程进行组织与控制的系统层。**

整个 Harness 分成两个主要部分：

```text
AI Harness
│
├── Inference Harness
│
└── Training Harness
```

两者分别解决两个问题：

### Inference Harness

> 当前任务怎样可靠完成？

主要管理：

```text
context
memory
state
workflow
tools
environment
model routing
validation
verification
evaluation
retry
fallback
governance
observability
```

### Training Harness

> 如何让下一版本模型变得更好？

主要管理：

```text
dataset
environment
rollout
trajectory
reward / verifier
SFT
LoRA
DPO
RL
evaluation
checkpoint
experiment
model registry
```

一个有用的区别是：

```text
Training Harness
→ primarily changes model weights

Inference Harness
→ primarily changes runtime state
```

但二者都会产生 trajectory、evaluation、feedback 和 artifacts。

---

# 5. Media Creation 的核心执行闭环

当前核心业务流程定义为：

```text
User Intent
      ↓
Creative Agent
      ↓
Creative Specification
      ↓
Harness Orchestrator
      ↓
UE5 Scene Environment
      ↓
Media Condition Compiler
      ↓
WAN / Media Model
      ↓
Generated Media
      ↓
Verification Harness
      ↓
VLM / CV / Rules
      ↓
PASS ───────────────→ Artifact
 │
 FAIL
 │
 ↓
Failure Diagnosis
 ↓
Repair / Retry / Route
 ↓
Generation
```

这形成一个典型 Agentic Loop：

```text
Perceive
→ Reason
→ Act
→ Observe
→ Verify
→ Adapt
```

但 Agent 的目的不是聊天，而是：

> **控制 Media Creation Environment。**

---

# 6. Creative Specification

系统不应该直接把 User Prompt 传给 WAN。

需要引入中间表示：

> **Creative Specification**

例如：

```text
CreativeSpec
├── intent
├── modality
├── scene
├── camera
├── lighting
├── character
├── pose
├── motion
├── style
├── references
├── constraints
├── generation parameters
└── quality requirements
```

核心转换过程因此成为：

```text
Natural Language
      ↓
Creative Specification
      ↓
Executable Media Conditions
```

---

# 7. UE5 的系统定位

UE5 暂时不用于开发完整 Interactive Game。

它在系统中作为：

> **Controllable Scene Environment / Reference Environment**

主要承担：

```text
Camera
Lighting
Geometry
Pose
Spatial Layout
Motion
Scene Reference
```

UE5 可以同时工作在 generation 前后。

### Pre-generation

```text
CreativeSpec
     ↓
UE5 Scene
     ↓
Reference Render
Depth
Normal
Camera Metadata
Lighting Metadata
     ↓
Media Condition Compiler
     ↓
WAN
```

作用：

> **Generation Guidance**

### Post-generation

```text
UE5 Reference State
          ↘
           Comparator
          ↗
Generated Media
      ↓
VLM / CV
      ↓
Estimated Scene State
```

作用：

> **Semantic Verification**

核心思想：

> 尽可能将模糊的 semantic constraints 转化为 observable / measurable properties。

例如：

```text
"low-angle shot"

        ↓

target camera specification

        ↓

generated media

        ↓

estimated camera properties

        ↓

deviation / quality score
```

---

# 8. Media Condition Compiler

系统长期不应局限于 Prompt Generator。

更合理的抽象是：

> **Media Condition Compiler**

输入：

```text
Creative Specification
+
UE5 Scene State
```

输出可能包括：

```text
text prompt
negative prompt
reference image
depth
pose
mask
camera trajectory
workflow
model parameters
```

因此：

```text
Creative Specification
          ↓
Media Condition Compiler
          ↓
Executable Generation Conditions
          ↓
WAN
```

---

# 9. Semantic Correctness

AI System 至少需要区分：

```text
Structural Correctness
Functional Correctness
Semantic Correctness
```

例如一个合法 JSON：

```text
{
    prompt: "summer beach"
}
```

即使 Schema 正确，如果用户要求的是 Montréal snow scene，仍然属于 semantic failure。

因此 Harness Quality Layer 需要区分：

### Validation

回答：

> Is the output structurally valid?

例如：

```text
JSON valid?
Schema valid?
Required fields?
Types?
Ranges?
```

### Verification

回答：

> Is this result correct for the current task?

例如：

```text
camera correct?
lighting correct?
requested object present?
code passes tests?
media satisfies required constraints?
```

### Evaluation

回答：

> How good is the result?

例如：

```text
prompt_adherence       0.91
camera_match           0.83
lighting_match         0.74
temporal_consistency   0.87
```

因此：

```text
Validation
= valid?

Verification
= correct?

Evaluation
= how good?
```

Evaluation 不能只用于报告，它应该参与 Harness Runtime Control：

```text
score
 ↓
accept
retry
repair
fallback
route
```

---

# 10. Distributed / Microservice Architecture

虽然当前开发规模较小，但系统从设计阶段按照：

> **Distributed + Microservice-ready Architecture**

进行设计。

重要原则：

> Logical decomposition ≠ Physical deployment decomposition.

架构上可以定义多个 logical services，但开发阶段可以将多个服务部署在同一个 container/process 中。

核心服务边界：

```text
API Gateway

Creative Service
    ↓
Harness Orchestrator

├── LLM Service
├── Scene Service / UE5 Worker
├── Generation Service / WAN Worker
├── Verification Service / VLM-CV
├── Artifact Service
├── Model Registry
└── Training Service
```

基础设施：

```text
PostgreSQL
Redis
Message Broker
MinIO / S3
GPU Worker Pools
Observability Stack
Container Runtime
```

---

# 11. Control Plane / Execution Plane

Harness Orchestrator 属于：

> **Control Plane**

负责：

```text
what to execute
when to execute
which model
which worker
workflow
state
routing
retry
policy
quality threshold
```

GPU Workers 属于：

> **Execution Plane**

例如：

```text
LLM Workers
WAN Workers
VLM Workers
UE5 Workers
```

执行具体计算任务。

这样能够实现：

```text
independent scaling
failure isolation
GPU-aware scheduling
model routing
resource control
```

---

# 12. Async / Event-driven Architecture

Media Generation 属于 long-running GPU workload，因此不应该依赖长时间 synchronous HTTP connection。

基本模式：

```text
POST /generation
      ↓
202 Accepted
      ↓
job_id
      ↓
Message Queue
      ↓
GPU Worker
      ↓
Artifact
      ↓
completion event
```

整个媒体 pipeline 可以成为：

```text
scene.build
      ↓
scene.completed
      ↓
generation.video
      ↓
generation.completed
      ↓
verification.request
      ↓
verification.completed
```

这一部分将作为学习 distributed systems 的重要载体。

---

# 13. System Design 学习策略

项目实现遵循：

```text
Requirement
     ↓
Failure Scenario
     ↓
Design Decision
     ↓
Minimal Implementation
     ↓
Trade-off
     ↓
Scaling Discussion
```

例如：

```text
Requirement:
同一个任务不能被重复执行。

Failure:
message 被 broker 重复投递。

Question:
What happens?

Design:
Idempotency

Minimal implementation:
job_id / event_id
+
database unique constraint
```

重点不是简单学习：

```text
How to use Kafka?
```

而是理解：

```text
Why does this problem naturally lead to
queue / idempotency / outbox / retry / DLQ?
```

---

# 14. 需要主动经历的 Distributed System 问题

项目将刻意用最小实现经历以下问题：

```text
Async Jobs
Message Queue
Worker Pool

Idempotency
At-least-once Delivery
Deduplication

Retry
Exponential Backoff
Timeout
Circuit Breaker
Dead Letter Queue

Transactional Outbox
Eventual Consistency
Dual-write Problem

Optimistic Locking
Distributed Lock
Job Lease

Backpressure
Rate Limiting
Autoscaling

Cache
TTL
Cache Invalidation

Load Balancing
GPU-aware Scheduling

Observability
Logs
Metrics
Distributed Tracing

SLO / SLA
p95 latency
job success rate
semantic success rate
```

实现可以很小，但每个机制必须能够解释：

1. 为什么需要？
2. 它解决什么 failure？
3. 有什么 trade-off？
4. 如果流量增加 100 倍怎么办？

---

# 15. GPU-aware AI Infrastructure

AI workload 与普通 backend workload 不同。

需要考虑：

```text
VRAM
model size
model affinity
model warm-up
cold loading
GPU utilization
batching
priority
queue depth
GPU fragmentation
worker capability
```

长期调度模型：

```text
Task
 ↓
Model Requirement
 ↓
Resource Requirement
 ↓
GPU Worker Pool
 ↓
Execution
```

例如：

```text
WAN-large
→ high-VRAM pool

small VLM
→ low-VRAM pool

LLM
→ LLM inference pool
```

这部分是 AI Systems Engineering 与传统 Backend System Design 的重要交叉点。

---

# 16. Post-training 是系统的一等组成部分

虽然当前硬件、数据、时间条件不足以进行大规模 post-training，但不能把 Training 当作系统之外的附属实验。

当前首先完成最小生命周期：

```text
Base Model
   ↓
small SFT dataset
   ↓
LoRA
   ↓
My Post-trained Model
   ↓
Evaluation
   ↓
Model Registry
   ↓
Inference
```

当前实验模型：

```text
1. Base Model

2. Official Optimized / Instruct Model

3. My Post-trained Model
   currently minimal SFT/LoRA

4. Application Model
   WAN
```

前三者尽可能使用相同 family / parameter scale，以观察 post-training 带来的行为变化。

---

# 17. Learning Data Plane

Inference Harness 从第一天开始就应该考虑：

> **How can production experience become future training data?**

因此保存 Task Trace：

```text
TaskTrace
├── user_intent
├── creative_spec
├── context
├── model_version
├── UE5 scene spec
├── generated conditions
├── WAN parameters
├── generated artifacts
├── verifier outputs
├── evaluation scores
├── retry trajectory
├── user modifications
└── accepted result
```

然后：

```text
Inference Harness
       ↓
Trace / Event
       ↓
Learning Data Plane
       ↓
filtering
deduplication
failure mining
labeling
dataset construction
dataset versioning
       ↓
Training Harness
```

最终形成：

```text
Production
    ↓
Evaluation
    ↓
Failure Mining
    ↓
Dataset
    ↓
Post-training
    ↓
Candidate Model
    ↓
Regression Evaluation
    ↓
Deployment
```

---

# 18. Model Lifecycle / Lineage

Model 不应只是一个 `.safetensors` 文件。

系统中的 ModelVersion 应包含：

```text
ModelVersion
├── base_model
├── training_method
├── dataset_version
├── training_config
├── checkpoint / adapter
├── prompt/template version
├── evaluation results
├── runtime requirements
├── deployment status
└── lineage
```

最终系统应该能够回答：

```text
request
 ↓
deployment
 ↓
model version
 ↓
checkpoint
 ↓
training run
 ↓
dataset version
```

实现：

> **Reproducibility + Model Lineage**

---

# 19. 三个核心闭环

整个 Orvexa AI System 最终可以理解为三个 loop。

### Loop 1 — Media Creation

```text
Intent
→ Specify
→ Generate
→ Verify
→ Iterate
```

### Loop 2 — Runtime Reliability

```text
Execute
→ Observe
→ Detect Failure
→ Retry / Recover
```

### Loop 3 — Learning

```text
Production
→ Evaluate
→ Collect Data
→ Train
→ Evaluate
→ Deploy
```

前两个主要属于：

> **Inference Harness**

第三个主要属于：

> **Training Harness / Post-training**

三者共同组成完整 AI System。

---

# 20. 项目最终希望建立的能力

项目不是为了成为：

* Diffusion researcher
* WAN researcher
* UE5 game developer
* Chatbot developer

而是通过对这些组件的理解和使用，建立：

```text
Backend System Design
        +
Distributed Systems
        +
AI System Design
        +
Harness Engineering
        +
Post-training Understanding
        +
Agentic Engineering
        +
Basic Generative Media Engineering
```

最终职业方向：

> **Agentic AI Engineer / AI Systems Engineer**

核心能力是：

> 能够把概率性的 Model Capability，通过 Harness、Environment、Verification、Distributed Infrastructure 和 Learning Loop，组织成可靠、可扩展、可持续改进的 AI System。

---

## Current Architecture Thesis

Orvexa 的核心架构思想暂时总结为：

> **Model provides probabilistic capability. Harness turns that capability into system behavior. Verification makes the behavior measurable. Distributed infrastructure makes it scalable and reliable. Post-training allows production experience to improve future model behavior.**

因此项目的重点不只是：

> How do I call a model?

而是持续回答三个问题：

**1. System Design**

> How does the system remain scalable, observable and reliable under failures and load?

**2. Harness Design**

> How does the system control uncertain model behavior and maintain semantic correctness?

**3. Learning System**

> How does production experience become better future model behavior?

这三个问题将作为后续 Orvexa 开发与学习的主线。

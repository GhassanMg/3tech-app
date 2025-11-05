import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { MtnController } from './mtn.controller';
import { MtnService } from './mtn.service';

@Module({
  imports: [
    HttpModule.register({
      timeout: 30000,
      maxRedirects: 5,
    }),
  ],
  controllers: [MtnController],
  providers: [MtnService],
  exports: [MtnService],
})
export class MtnModule {}

